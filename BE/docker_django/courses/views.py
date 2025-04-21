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






from . import perms
from .models import Category, Course, Lesson, User, Video, Payment, DeviceToken, Note
from .serializers import VideoSerializer, CourseSerializer, DeviceTokenSerializer, LessonSerializer, NoteSerializer


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
            category = self.get_object()  # Lấy Category theo pk
            user = request.user  # Lấy user hiện tại từ request

            # Lọc ra khoá học trong category
            courses = Course.objects.filter(category=category)

            # Lọc khoá học mà người dùng chưa thanh toán (trong Payment)
            unpaid_courses = []

            for course in courses:
                # Kiểm tra xem người dùng đã thanh toán chưa cho khoá học này
                payment = Payment.objects.filter(user=user, course=course).first()

                if not payment or payment.status == False:  # Nếu chưa thanh toán hoặc thanh toán thất bại
                    unpaid_courses.append(course)

            # Serialize lại danh sách khoá học chưa thanh toán
            serializer = CourseSerializer(unpaid_courses, many=True, context={'request': request})

            return Response(serializer.data, status=status.HTTP_200_OK)

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
        if self.action in ['paid_courses', 'lessons']:
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
        if self.action.__eq__('current_user'):
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
                    'password':  make_password(password),
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

    @action(methods=['get'], url_name='current-users', detail=False)
    def current_user(self, request):
        return Response(serializers.UserSerializer(request.user).data)


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
            return Response({'detail': str(e)}, status=status.HTTP_400_BAD_REQUEST)


class ResetPasswordRequestViewSet(viewsets.ViewSet):
    def create(self, request):
        email = request.data.get("email")
        if not email:
            return Response({"message": "Please enter your email"}, status=status.HTTP_400_BAD_REQUEST)

        user = User.objects.filter(email=email).first()
        if user:
            uid = urlsafe_base64_encode(force_bytes(user.pk))
            token = default_token_generator.make_token(user)

            # Link gốc mà app Flutter xử lý
            deep_link = f"{settings.URL}/reset-password?uid={uid}&token={token}"

            # Gửi yêu cầu tạo Dynamic Link ngắn
            firebase_api_key = settings.FIREBASE_API_KEY
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
            else:
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
            return Response({"message": "New password cannot be the same as the old password"}, status=status.HTTP_400_BAD_REQUEST)

        user.set_password(new_password)
        user.save()
        return Response({"message": "Password has been reset"}, status=status.HTTP_200_OK)

# class VideoViewSet(viewsets.ViewSet, generics.CreateAPIView):
#     queryset = Video.objects.all()
#     serializer_class = VideoSerializer
#     parser_classes = [MultiPartParser]  # Để xử lý form-data với file
#
#     def create(self, request):
#         serializer = self.serializer_class(data=request.data)
#
#         if serializer.is_valid():
#             video_instance = serializer.save(url=None)  # Lưu instance video với url=None ban đầu
#
#             # Kiểm tra xem 'url' có trong request.FILES hay không
#             if 'url' in request.FILES:
#                 video_file = request.FILES['url']
#
#                 # Tạo thư mục tạm nếu chưa tồn tại
#                 temp_dir = '/path/to/temp/dir'  # Đường dẫn tới thư mục tạm
#                 if not os.path.exists(temp_dir):
#                     os.makedirs(temp_dir)
#
#                 # Lưu tệp video tạm thời
#                 if isinstance(video_file, (InMemoryUploadedFile, TemporaryUploadedFile)):
#                     temp_file_path = os.path.join(temp_dir, video_file.name)
#                     with open(temp_file_path, 'wb') as temp_file:
#                         for chunk in video_file.chunks():
#                             temp_file.write(chunk)
#
#                     # Gửi task lên Celery để upload file lên S3
#                     # upload_video_to_s3.delay(temp_file_path, video_file.name, video_instance.id)
#
#             return Response(serializer.data, status=status.HTTP_201_CREATED)
#
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


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
        print(token)
        print(platform)

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


def successed(request):
    return render(request, 'payment_successful.html')


def cancelled(request):
    return render(request, 'payment_cancelled.html')
