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
import requests






from . import perms
from .models import Category, Course, Lesson, User, Video, Payment
from .serializers import VideoSerializer


class CategoryViewSet(viewsets.ViewSet, generics.ListAPIView):
    queryset = Category.objects.all()
    serializer_class = serializers.CategorySerializer


class CourseViewSet(viewsets.ViewSet, generics.ListAPIView, generics.CreateAPIView, generics.RetrieveAPIView):
    queryset = Course.objects.filter(active=True)
    serializer_class = serializers.CourseSerializer
    pagination_class = paginators.CoursePaginator

    def get_permissions(self):
        if self.action.__eq__('courses_bought'):
            return [permissions.IsAuthenticated()]
        return [permissions.AllowAny()]

    @action(methods=['get'], detail=False)
    def courses_bought(self, request):
        user = request.user
        # Lấy danh sách các khóa học mà user đã thanh toán thành công
        paid_courses_ids = Payment.objects.filter(user=user, status=True).values_list('course', flat=True)
        bought_courses = Course.objects.filter(id__in=paid_courses_ids)

        # Sử dụng paginator để phân trang
        paginator = self.paginator
        page = paginator.paginate_queryset(bought_courses, request)

        # Kiểm tra nếu có phân trang
        if page is not None:
            serializer = serializers.CourseSerializer(page, many=True, context={'request': request})
            return paginator.get_paginated_response(serializer.data)

        # Nếu không có phân trang, trả về tất cả dữ liệu
        serializer = serializers.CourseSerializer(bought_courses, many=True, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @action(methods=['get'], detail=True)
    def lessons(self, request, pk):
        lessons = self.get_object().lesson_set.filter(active=True)
        return Response(serializers.LessonSerializer(lessons, many=True, context={'request': request}).data,
                        status=status.HTTP_200_OK)


class LessonViewSet(viewsets.ViewSet, generics.RetrieveAPIView):
    queryset = Lesson.objects.filter(active=True)
    serializer_class = serializers.LessonSerializer

    def get_permissions(self):
        if self.action.__eq__('videos'):
            return [permissions.IsAuthenticated(), perms.IsPaymentGranted()]
        return [permissions.AllowAny()]

    @action(methods=['get'], detail=True)
    def videos(self, request, pk):
        videos = self.get_object().video_set.filter(active=True)
        return Response(serializers.VideoSerializer(videos, many=True).data, status=status.HTTP_200_OK)


class UserViewSet(viewsets.ViewSet, generics.CreateAPIView):
    queryset = User.objects.filter(is_active=True)
    serializer_class = serializers.UserSerializer
    parser_classes = [parsers.MultiPartParser]

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
            print(f'email {email_verified}')


            if not email_verified:
                return Response({'error': 'Email chưa được xác minh'}, status=400)

            # Kiểm tra trùng username (nếu cần)
            if User.objects.filter(username=username).exists():

                return Response({'error': 'Username đã được sử dụng'}, status=400)

                # Kiểm tra trùng username (nếu cần)
            if User.objects.filter(phone=phone).exists():
                return Response({'error': 'Số điện thoai đã được sử dụng'}, status=400)

            # Tạo user mới
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

    def get_permissions(self):
        if self.action.__eq__('current_user'):
            return [permissions.IsAuthenticated()]
        return [permissions.AllowAny()]

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

class VideoViewSet(viewsets.ViewSet, generics.CreateAPIView):
    queryset = Video.objects.all()
    serializer_class = VideoSerializer
    parser_classes = [MultiPartParser]  # Để xử lý form-data với file

    def create(self, request):
        serializer = self.serializer_class(data=request.data)

        if serializer.is_valid():
            video_instance = serializer.save(url=None)  # Lưu instance video với url=None ban đầu

            # Kiểm tra xem 'url' có trong request.FILES hay không
            if 'url' in request.FILES:
                video_file = request.FILES['url']

                # Tạo thư mục tạm nếu chưa tồn tại
                temp_dir = '/path/to/temp/dir'  # Đường dẫn tới thư mục tạm
                if not os.path.exists(temp_dir):
                    os.makedirs(temp_dir)

                # Lưu tệp video tạm thời
                if isinstance(video_file, (InMemoryUploadedFile, TemporaryUploadedFile)):
                    temp_file_path = os.path.join(temp_dir, video_file.name)
                    with open(temp_file_path, 'wb') as temp_file:
                        for chunk in video_file.chunks():
                            temp_file.write(chunk)

                    # Gửi task lên Celery để upload file lên S3
                    # upload_video_to_s3.delay(temp_file_path, video_file.name, video_instance.id)

            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def successed(request):
    return render(request, 'payment_successful.html')


def cancelled(request):
    return render(request, 'cancelled.html')
