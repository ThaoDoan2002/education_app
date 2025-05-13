from datetime import datetime
import os

from celery import shared_task
import boto3
from django.core.mail import send_mail

from courses.models import Video, User, DeviceToken
import time

from django.conf import settings
from firebase_admin import messaging
from firebase_admin._messaging_utils import UnregisteredError




@shared_task
def upload_video_to_s3(file_path, filename, video_instance_id):

    time.sleep(3)
    print(f"🎬 Uploading file: {file_path}")  # Debug

    if not os.path.exists(file_path):
        print(f"❌ ERROR: File does not exist: {file_path}")
        return
    print('upload video')
    s3 = boto3.client(
        's3',
        aws_access_key_id=settings.AWS_ACCESS_KEY_ID,
        aws_secret_access_key=settings.AWS_SECRET_ACCESS_KEY,
        region_name=settings.AWS_S3_REGION_NAME
    )

    try:
        # Lấy instance video từ database
        video_instance = Video.objects.get(id=video_instance_id)

        current_time = datetime.now()

        s3_key = f"courses/{current_time.strftime('%Y')}/{current_time.strftime('%m')}/{os.path.basename(filename)}"

        # Tải video lên S3 từ file tạm thời
        with open(file_path, 'rb') as video_file:
            s3.upload_fileobj(
                video_file,
                settings.AWS_STORAGE_BUCKET_NAME,
                s3_key,
                ExtraArgs={
                    'ContentDisposition': 'inline',  # Đảm bảo video không tải xuống mà phát trực tiếp
                    'ContentType': 'video/mp4'  # Đặt đúng loại MIME để phát video
                }
            )

            # Lưu URL của video vào instance video
        video_instance.url = f'{s3_key}'
        video_instance.save()



        # Xóa file tạm sau khi upload thành công
        os.remove(file_path)
        print("Preparing to send email")
        # Gửi email cho admin
        send_mail(
            subject='Video đã tải lên',
            message=f'Login to seen uploaded',
            from_email=settings.DEFAULT_FROM_EMAIL,
            recipient_list=[settings.ADMIN_EMAIL],  # Địa chỉ email của admin
            fail_silently=False,
        )

    except Exception as e:
        print(f"An error occurred: {e}")


@shared_task
def send_payment_success_email(user_id, course_name):
    user = User.objects.get(id=user_id)
    subject = f"Thanh toán thành công cho khóa học {course_name}"
    message = f"Chào {user.username},\n\nBạn đã thanh toán thành công cho khóa học {course_name}. Chúc bạn học tốt!"
    from_email = settings.EMAIL_HOST_USER

    send_mail(subject, message, from_email, [user.email])


@shared_task
def send_delayed_push_notification(token, title, body):
    time.sleep(3)
    message = messaging.Message(
        notification=messaging.Notification(
            title=title,
            body=body
        ),
        token=token
    )
    try:
        response = messaging.send(message)
        print(f"Push sent to {token}: {response}")
    except UnregisteredError:
        DeviceToken.objects.filter(token=token).delete()
        print(f"Token không hợp lệ, đã xóa: {token}")
    except Exception as e:
        print(f"Lỗi khi gửi push đến {token}: {str(e)}")




