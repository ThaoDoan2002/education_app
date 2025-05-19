import os

from django.core.files.uploadedfile import InMemoryUploadedFile, TemporaryUploadedFile

from django.shortcuts import render

from rest_framework import viewsets, generics, status, parsers, permissions
from django.contrib.auth.hashers import make_password

from urllib.parse import quote

from courseapp import settings
from courses import serializers, paginators
from rest_framework.decorators import action
from rest_framework.parsers import MultiPartParser
from rest_framework.response import Response
from firebase_admin import auth as firebase_auth
from oauth2_provider.models import Application, AccessToken, RefreshToken
from oauthlib.common import generate_token
from django.utils import timezone
from datetime import timedelta
from django.utils.http import urlsafe_base64_encode
from django.utils.http import urlsafe_base64_decode
from django.utils.encoding import force_bytes
from django.contrib.auth.tokens import default_token_generator
from django.core.mail import send_mail
from rest_framework.permissions import IsAuthenticated
import requests
import random

from . import perms
from .models import Category, Course, Lesson, User, Video, Payment, DeviceToken, Note, EmailOTP
from .paginators import CoursePaginator
from .serializers import VideoSerializer, CourseSerializer, DeviceTokenSerializer, LessonSerializer, NoteSerializer, \
    RegisterSerializer, UpdateUserInfoSerializer
from google.cloud import texttospeech
from django.http import HttpResponse
import os

from .tasks import send_welcome_email_task


class CategoryViewSet(viewsets.ViewSet, generics.ListAPIView, generics.RetrieveAPIView):
    queryset = Category.objects.all()
    serializer_class = serializers.CategorySerializer

    def get_permissions(self):
        if self.action.__eq__('courses_by_category') | self.action.__eq__('paid-courses'):
            return [permissions.IsAuthenticated()]
        return [permissions.AllowAny()]

    @action(detail=True, methods=['get'], url_path='courses')
    def courses_by_category(self, request, pk=None):
        try:
            category = self.get_object()
            user = request.user

            courses = Course.objects.filter(category=category)

            unpaid_courses = []
            for course in courses:
                payment = Payment.objects.filter(user=user, course=course).first()
                if not payment or payment.status is False:
                    unpaid_courses.append(course)

            paginator = CoursePaginator()
            page = paginator.paginate_queryset(unpaid_courses, request)

            serializer = CourseSerializer(page, many=True, context={'request': request})
            return paginator.get_paginated_response(serializer.data)

        except Category.DoesNotExist:
            return Response({'error': 'Category không tồn tại'}, status=status.HTTP_404_NOT_FOUND)

    @action(detail=True, methods=['get'], url_path='paid-courses')
    def paid_courses(self, request, pk=None):
        try:
            category = self.get_object()  # Lấy Category theo pk
            user = request.user  # Lấy user hiện tại từ request

            # Lọc ra khoá học trong category mà người dùng đã thanh toán
            purchased_courses = Course.objects.filter(
                category=category,
                payment__user=user,
                payment__status=True
            ).distinct()  # Lọc khoá học không trùng lặp

            # Serialize lại danh sách khoá học đã thanh toán
            serializer = CourseSerializer(purchased_courses, many=True, context={'request': request})

            return Response(serializer.data, status=status.HTTP_200_OK)

        except Category.DoesNotExist:
            return Response({'error': 'Category không tồn tại'}, status=status.HTTP_404_NOT_FOUND)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


class CourseViewSet(viewsets.ViewSet, generics.ListAPIView, generics.CreateAPIView, generics.RetrieveAPIView):
    queryset = Course.objects.filter(active=True)
    serializer_class = serializers.CourseSerializer
    pagination_class = paginators.CoursePaginator

    def get_permissions(self):
        if self.action in ['paid_courses', 'lessons', 'unpaid_courses']:
            return [permissions.IsAuthenticated()]
        return [permissions.AllowAny()]

    @action(detail=False, methods=['get'], url_path='paid-courses')
    def paid_courses(self, request):
        try:
            user = request.user  # Lấy user hiện tại từ request

            # Lọc ra các khoá học mà người dùng đã thanh toán
            paid_courses = Course.objects.filter(payment__user=user, payment__status=True).distinct()

            # Serialize lại danh sách khoá học đã thanh toán
            serializer = CourseSerializer(paid_courses, many=True, context={'request': request})

            return Response(serializer.data, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=True, methods=['get'], url_path='lessons')
    def lessons(self, request, pk=None):
        try:
            course = Course.objects.get(pk=pk, active=True)

            # Kiểm tra nếu người dùng đã thanh toán khoá học này
            if not Payment.objects.filter(user=request.user, course=course, status=True).exists():
                return Response({'error': 'Bạn chưa thanh toán khoá học này!'}, status=status.HTTP_403_FORBIDDEN)

            lessons = course.lessons.all()  # hoặc course.lessons.all() nếu bạn đặt related_name='lessons'
            serializer = LessonSerializer(lessons, many=True, context={'request': request})  # ✅ THÊM context
            return Response(serializer.data, status=status.HTTP_200_OK)

        except Course.DoesNotExist:
            return Response({'error': 'Khoá học không tồn tại!'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            print(e)
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['get'], url_path='unpaid-courses')
    def unpaid_courses(self, request):
        user = request.user
        search_query = request.query_params.get('search', '')

        # Lọc các khoá học người dùng **chưa thanh toán**
        paid_courses = Payment.objects.filter(user=user, status=True).values_list('course_id', flat=True)

        # Lọc khoá học chưa thanh toán, active và theo từ khoá tìm kiếm
        unpaid_courses = Course.objects.filter(
            active=True
        ).exclude(id__in=paid_courses)

        if search_query:
            unpaid_courses = unpaid_courses.filter(name__icontains=search_query)

        # Thực hiện phân trang
        paginator = self.pagination_class()
        paginated_courses = paginator.paginate_queryset(unpaid_courses, request)
        serializer = self.get_serializer(paginated_courses, many=True, context={'request': request})

        # Trả về kết quả phân trang
        return paginator.get_paginated_response(serializer.data)


class LessonViewSet(viewsets.ViewSet, generics.RetrieveAPIView):
    queryset = Lesson.objects.filter(active=True)
    serializer_class = serializers.LessonSerializer

    def get_permissions(self):
        if self.action.__eq__('video'):
            return [permissions.IsAuthenticated(), perms.IsPaymentGranted()]
        return [permissions.AllowAny()]

    @action(methods=['get'], detail=True)
    def video(self, request, pk):
        try:
            lesson = self.get_object()  # lesson
            video = lesson.video  # lấy video từ quan hệ OneToOneField

            if not video.active:
                return Response({'error': 'Video chưa được kích hoạt'}, status=status.HTTP_403_FORBIDDEN)

            serializer = serializers.VideoDetailSerializer(video, context={'request': request})
            return Response(serializer.data, status=status.HTTP_200_OK)

        except Video.DoesNotExist:
            return Response({'error': 'Bài học chưa có video'}, status=status.HTTP_404_NOT_FOUND)


class UserViewSet(viewsets.ViewSet, generics.CreateAPIView):
    queryset = User.objects.filter(is_active=True)
    serializer_class = serializers.UserSerializer
    parser_classes = [parsers.MultiPartParser]

    def get_permissions(self):
        if self.action.__eq__('current_user') | self.action.__eq__('edit_avatar')| self.action.__eq__('update_info'):
            return [permissions.IsAuthenticated()]
        return [permissions.AllowAny()]

    def create(self, request):
        token = request.data.get('token')
        username = request.data.get('username')
        password = request.data.get('password')
        phone = request.data.get('phone')
        firstName = request.data.get('firstName')
        lastName = request.data.get('lastName')

        if not username or not password:
            return Response({'error': 'Vui lòng nhập đầy đủ username và password'}, status=400)

        try:
            decoded_token = firebase_auth.verify_id_token(token)
            firebase_uid = decoded_token['uid']
            email = decoded_token['email']
            email_verified = decoded_token['email_verified']

            if not email_verified:
                return Response({'error': 'Email chưa được xác minh'}, status=400)

            if User.objects.filter(username=username).exists():
                return Response({'error': 'Username đã được sử dụng'}, status=400)

            if User.objects.filter(phone=phone).exists():
                return Response({'error': 'Số điện thoai đã được sử dụng'}, status=400)

            user, created = User.objects.get_or_create(
                firebase_uid=firebase_uid,
                defaults={
                    'email': email,
                    'username': username,
                    'password': make_password(password),
                    'phone': phone,
                    'first_name': firstName,
                    'last_name': lastName
                }
            )

            if not created:
                return Response({'error': 'Tài khoản đã tồn tại'}, status=400)

            return Response({'message': 'Đăng ký thành công'})

        except Exception as e:
            return Response({'error': str(e)}, status=400)

    @action(methods=["patch"], detail=False, url_path='update-info')
    def update_info(self, request):
        user = request.user
        data = {
            "first_name": request.data.get("firstName"),
            "last_name": request.data.get("lastName"),
            "phone": request.data.get("phone"),
        }

        serializer = UpdateUserInfoSerializer(user, data=data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Thông tin đã được cập nhật", "user": serializer.data},
                            status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


    @action(methods=['get'], url_name='current-users', detail=False)
    def current_user(self, request):
        return Response(serializers.UserSerializer(request.user).data)

    @action(methods=['patch'], url_name='edit-avatar', detail=False)
    def edit_avatar(self, request):
        user = request.user

        avatar = request.FILES.get('avatar')

        if avatar:
            user.avatar = avatar

        user.save()

        return Response({'message': 'Cập nhật thông tin thành công'}, status=status.HTTP_200_OK)


class FirebaseLoginViewSet(viewsets.ViewSet):
    def create(self, request):
        id_token = request.data.get('idToken')
        if not id_token:
            return Response({'error': 'Missing idToken'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            decoded = firebase_auth.verify_id_token(id_token)
            uid = decoded['uid']
            email = decoded.get('email')
            name = decoded.get('name', '')

            user, _ = User.objects.get_or_create(
                email=email,
                defaults={'username': name or email.split('@')[0]}
            )

            # Lấy ứng dụng OAuth2 đã tạo sẵn
            app = Application.objects.get(name="EnglishCourses")

            # Tạo access token và refresh token
            access_token = AccessToken.objects.create(
                user=user,
                token=generate_token(),
                application=app,
                expires=timezone.now() + timedelta(seconds=3600),
                scope='read write'
            )

            refresh_token = RefreshToken.objects.create(
                user=user,
                token=generate_token(),
                application=app,
                access_token=access_token
            )

            return Response({
                'access_token': access_token.token,
                'refresh_token': refresh_token.token,
                'expires_in': 3600,
                'token_type': 'Bearer'
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({'detail': str(e)}, status=status.HTTP_200_OK)


class ResetPasswordRequestViewSet(viewsets.ViewSet):
    def create(self, request):
        email = request.data.get("email")
        if not email:
            return Response({"message": "Please enter your email"}, status=status.HTTP_400_BAD_REQUEST)

        user = User.objects.filter(email=email).first()
        if user:
            uid = urlsafe_base64_encode(force_bytes(user.pk))
            token = default_token_generator.make_token(user)
            print(settings.URL)
            # Link gốc mà app Flutter xử lý
            deep_link = f"{settings.URL}/reset-password?uid={uid}&token={token}"

            # Gửi yêu cầu tạo Dynamic Link
            firebase_api_key = 'AIzaSyC-cbQLVI5dXsfxGCEdRvBhiV6aAY2ov3E'
            firebase_url = f"https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key={firebase_api_key}"
            payload = {
                "dynamicLinkInfo": {
                    "domainUriPrefix": "https://educationapi.page.link",
                    "link": deep_link,
                    "androidInfo": {
                        "androidPackageName": "com.dtt.education_project"
                    },
                    "iosInfo": {
                        "iosBundleId": "com.dtt.education_project"
                    }
                }
            }

            response = requests.post(firebase_url, json=payload)
            if response.status_code == 200:
                short_link = response.json().get("shortLink")

            if response.status_code != 200:
                print(f"Error Code: {response.status_code}")
                print(f"Response: {response.json()}")
                return Response({"message": "Failed to generate reset link"}, status=500)
            # Gửi email
            send_mail(
                "Reset your password",
                f"Click this link to reset your password: {short_link}",
                "noreply@example.com",
                [user.email],
                fail_silently=False,
            )
        else:
            return Response({"message": "Email not exists!"}, status=status.HTTP_400_BAD_REQUEST)

        return Response({"message": "If the email exists, a reset link has been sent."}, status=status.HTTP_200_OK)


class ResetPasswordConfirmViewSet(viewsets.ViewSet):
    def create(self, request):
        uid = request.data.get("uid")
        token = request.data.get("token")
        new_password = request.data.get("new_password")

        if not uid:
            return Response({'message': 'Missing uid'}, status=status.HTTP_400_BAD_REQUEST)
        if not token:
            return Response({'message': 'Missing token'}, status=status.HTTP_400_BAD_REQUEST)
        if not new_password:
            return Response({'message': 'Missing new_password'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            uid = urlsafe_base64_decode(uid).decode()
            user = User.objects.get(pk=uid)
        except (TypeError, ValueError, OverflowError, User.DoesNotExist):
            return Response({"message": "Invalid user"}, status=status.HTTP_400_BAD_REQUEST)

        if not default_token_generator.check_token(user, token):
            return Response({"message": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST)

        if user.check_password(new_password):
            return Response({"message": "New password cannot be the same as the old password"},
                            status=status.HTTP_400_BAD_REQUEST)

        user.set_password(new_password)
        user.save()
        return Response({"message": "Password has been reset"}, status=status.HTTP_200_OK)


class VideoViewSet(viewsets.ViewSet, generics.CreateAPIView):
    queryset = Video.objects.all()
    serializer_class = VideoSerializer
    parser_classes = [MultiPartParser]
    permission_classes = [IsAuthenticated]

    @action(detail=True, methods=['get'])
    def notes(self, request, pk=None):
        video = self.get_object()
        user = request.user
        notes = Note.objects.filter(video=video, user=user).order_by('timestamp')
        serializer = NoteSerializer(notes, many=True)
        return Response(serializer.data)


class SaveDeviceTokenView(viewsets.ViewSet):
    permission_classes = [IsAuthenticated]

    def create(self, request):
        user = request.user if request.user.is_authenticated else None
        token = request.data.get('token')
        platform = request.data.get('platform')

        device, created = DeviceToken.objects.update_or_create(
            token=token,
            defaults={'user': user, 'platform': platform}
        )

        return Response({'message': 'Token saved'})


class NoteViewSet(viewsets.ViewSet):
    permission_classes = [permissions.IsAuthenticated]

    def create(self, request):
        video = request.data.get('video_id')
        timestamp = request.data.get('timestamp')
        content = request.data.get('content')

        if not video or timestamp is None:
            return Response(
                {"error": "Thiếu video hoặc timestamp"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Tìm ghi chú đã tồn tại chưa
        note, created = Note.objects.update_or_create(
            user=request.user,
            video_id=video,
            timestamp=timestamp,
            defaults={'content': content}
        )

        serializer = NoteSerializer(note)
        if created:
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.data, status=status.HTTP_200_OK)

    def get(self, request):
        video_id = request.query_params.get('video_id')
        timestamp = request.query_params.get('timestamp')

        if not video_id or timestamp is None:
            return Response({"error": "Thiếu video hoặc timestamp"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            note = Note.objects.get(user=request.user, video_id=video_id, timestamp=timestamp)
            serializer = NoteSerializer(note)
            return Response({"note": serializer.data}, status=status.HTTP_200_OK)
        except Note.DoesNotExist:
            return Response({"note": None}, status=status.HTTP_200_OK)

    def destroy(self, request, pk=None):
        try:
            note = Note.objects.get(pk=pk, user=request.user)
            note.delete()
            return Response({"message": "Đã xóa ghi chú"}, status=status.HTTP_204_NO_CONTENT)
        except Note.DoesNotExist:
            return Response({"error": "Không tìm thấy ghi chú"}, status=status.HTTP_404_NOT_FOUND)


class SendOtpView(viewsets.ViewSet):
    def create(self, request):
        email = request.data.get("email")
        otp = f"{random.randint(100000, 999999)}"

        EmailOTP.objects.update_or_create(
            email=email,
            defaults={"otp_code": otp, "created_at": timezone.now(), "is_verified": False}
        )

        # Gửi email
        send_mail(
            "Mã OTP xác nhận",
            f"Mã OTP của bạn là: {otp}",
            "your_email@example.com",
            [email],
            fail_silently=False,
        )

        return Response({"message": "Mã OTP đã được gửi"}, status=status.HTTP_200_OK)


class VerifyOtpView(viewsets.ViewSet):
    def create(self, request):
        email = request.data.get("email")
        otp = request.data.get("otp")

        try:
            otp_obj = EmailOTP.objects.get(email=email, otp_code=otp)
            if otp_obj.is_valid():
                otp_obj.is_verified = True
                otp_obj.save()
                return Response({"message": "Xác thực thành công"}, status=status.HTTP_200_OK)
            else:
                return Response({"error": "Mã OTP đã hết hạn"}, status=status.HTTP_400_BAD_REQUEST)
        except EmailOTP.DoesNotExist:
            return Response({"error": "Mã OTP không hợp lệ"}, status=status.HTTP_400_BAD_REQUEST)


class RegisterView(viewsets.ViewSet):
    def create(self, request):
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            send_welcome_email_task(user.email)  # giả sử bạn truyền email
            return Response({"message": "Đăng ký thành công!"})
        return Response(serializer.errors, status=400)


def successed(request):
    return render(request, 'payment_successful.html')


def cancelled(request):
    return render(request, 'payment_cancelled.html')


class TextToSpeechViewSet(viewsets.ViewSet):

    @action(detail=False, methods=['get'])
    def synthesize(self, request):
        text = request.GET.get("text", "Hello from Google Cloud TTS!")

        # Lấy giới tính
        gender_str = request.GET.get("gender", "neutral").lower()
        if gender_str == "male":
            gender = texttospeech.SsmlVoiceGender.MALE
        elif gender_str == "female":
            gender = texttospeech.SsmlVoiceGender.FEMALE
        else:
            gender = texttospeech.SsmlVoiceGender.NEUTRAL

        # Lấy tốc độ nói (nếu không có thì mặc định là 1.0)
        speaking_rate = float(request.GET.get("speaking_rate", 1.0))

        client = texttospeech.TextToSpeechClient()
        synthesis_input = texttospeech.SynthesisInput(text=text)

        voice = texttospeech.VoiceSelectionParams(
            language_code="en-US",
            ssml_gender=gender,
        )

        audio_config = texttospeech.AudioConfig(
            audio_encoding=texttospeech.AudioEncoding.MP3,
            speaking_rate=speaking_rate  # 👈 thêm dòng này
        )

        response = client.synthesize_speech(
            input=synthesis_input,
            voice=voice,
            audio_config=audio_config
        )

        return HttpResponse(response.audio_content, content_type="audio/mpeg")


