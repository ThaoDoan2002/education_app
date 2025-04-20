from courses.models import Category, Course, Lesson, User, Video, Payment, DeviceToken
from rest_framework import serializers



class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = '__all__'


class CourseSerializer(serializers.ModelSerializer):
    payment_status = serializers.SerializerMethodField()

    class Meta:
        model = Course
        fields = ['id', 'name', 'description', 'thumbnail', 'price', 'category', 'payment_status']

    def get_payment_status(self, obj):
        user = self.context['request'].user
        if user.is_authenticated:
            # Kiểm tra nếu user đã thanh toán cho khóa học này
            return Payment.objects.filter(user=user, course=obj, status=True).exists()
        return False


class VideoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Video
        fields = '__all__'


class LessonSerializer(serializers.ModelSerializer):
    payment_status = serializers.SerializerMethodField()
    class Meta:
        model = Lesson
        fields = ['id', 'title', 'description', 'course', 'payment_status']

    def get_payment_status(self, obj):
        user = self.context['request'].user
        if user.is_authenticated:
            # Kiểm tra nếu user đã thanh toán cho khóa học này
            return Payment.objects.filter(user=user, course=obj.course, status=True).exists()
        return False


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id','username', 'password', 'email', 'phone', 'first_name', 'last_name']
        extra_kwargs = {
            'password': {
                'write_only': True
            }
        }

    def create(self, validated_data):
        data = validated_data.copy()

        user = User(**data)
        user.set_password(data['password'])  #băm mật khẩu
        user.save()

        return user



class PaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Payment
        fields = '__all__'


class DeviceTokenSerializer(serializers.ModelSerializer):
    class Meta:
        model = DeviceToken
        fields = ['token', 'platform']

    def create(self, validated_data):
        user = self.context['request'].user
        token = validated_data['token']

        # Nếu token đã tồn tại, cập nhật platform và user
        device_token, created = DeviceToken.objects.update_or_create(
            token=token,
            defaults={'user': user, 'platform': validated_data['platform']}
        )
        return device_token