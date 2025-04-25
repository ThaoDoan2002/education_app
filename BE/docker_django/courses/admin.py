import os
import uuid

from django.conf import settings
from django.contrib import admin
from django.core.files.uploadedfile import InMemoryUploadedFile, TemporaryUploadedFile
from django.db.models import F, Sum, ExpressionWrapper
from django.template.response import TemplateResponse

from .forms import RevenueFilterForm
from .models import Category, Course, Lesson, User, Video, Payment, VideoTimeline
from .tasks import upload_video_to_s3
from django.urls import path


class CoursesAdminSite(admin.AdminSite):
    site_header = "StarLight"

    def get_urls(self):
        return [
            path('course-stats/', self.stats_view, name="course-stats")
        ] + super().get_urls()

    def stats_view(self, request):
        form = RevenueFilterForm(request.GET or None)
        payments = Payment.objects.filter(status=True)

        # Kiểm tra xem form có hợp lệ không
        if form.is_valid():
            course = form.cleaned_data.get('course')
            time_filter = form.cleaned_data.get('time_filter')

            if course != '' and time_filter == '':
                # Thống kê theo tên khóa học khi chỉ chọn khóa học
                payments = payments.filter(course=course)
                revenue_data = payments.values('course__name').annotate(
                    total_revenue=Sum('course__price')
                ).order_by('course__name')
                periods = [data['course__name'] for data in revenue_data]
                revenues = [data['total_revenue'] for data in revenue_data]

            elif time_filter != '' and course is None:
                # Thống kê theo thời gian khi chỉ chọn thời gian
                if time_filter == 'month':
                    # Lọc theo tháng và năm
                    payments = payments.annotate(year=F('created_date__year'), month=F('created_date__month'))
                    revenue_data = payments.values('year', 'month').annotate(
                        total_revenue=Sum('course__price')
                    ).order_by('year', 'month')  # Thống kê theo năm và tháng
                    periods = [f"{data['month']}/{data['year']}" for data in revenue_data]
                    revenues = [data['total_revenue'] for data in revenue_data]

                elif time_filter == 'year':
                    # Thống kê theo năm
                    payments = payments.annotate(year=F('created_date__year'))
                    revenue_data = payments.values('year').annotate(
                        total_revenue=Sum('course__price')
                    ).order_by('year')  # Thống kê theo năm
                    periods = [data['year'] for data in revenue_data]
                    revenues = [data['total_revenue'] for data in revenue_data]

            # Nếu chọn cả khóa học và thời gian, thống kê theo cả hai
            elif course != '' and time_filter != '':
                if time_filter == 'month':
                    # Lọc theo tháng và năm
                    payments = payments.annotate(year=F('created_date__year'), month=F('created_date__month'))
                    payments = payments.filter(course=course)  # Thêm điều kiện khóa học
                    revenue_data = payments.values('year', 'month').annotate(
                        total_revenue=Sum('course__price')
                    ).order_by('year', 'month')  # Thống kê theo cả khóa học và thời gian
                    periods = [f"{data['month']}/{data['year']}" for data in revenue_data]
                    revenues = [data['total_revenue'] for data in revenue_data]

                elif time_filter == 'year':
                    # Thống kê theo năm và khóa học
                    payments = payments.annotate(year=F('created_date__year'))
                    payments = payments.filter(course=course)  # Thêm điều kiện khóa học
                    revenue_data = payments.values('year').annotate(
                        total_revenue=Sum('course__price')
                    ).order_by('year')  # Thống kê theo cả khóa học và thời gian
                    periods = [data['year'] for data in revenue_data]
                    revenues = [data['total_revenue'] for data in revenue_data]

            # Nếu không chọn khóa học và không chọn thời gian
            else:
                periods = []
                revenues = []

        else:
            periods = []
            revenues = []

        context = {
            'form': form,
            'periods': periods,
            'revenues': revenues,
        }
        return TemplateResponse(request, 'admin/stats.html', context)

admin_site = CoursesAdminSite(name='myapp')


class LessonInlineAdmin(admin.StackedInline):
    model = Lesson
    extra = 1
    fk_name = 'course'


class CourseAdmin(admin.ModelAdmin):
    inlines = [LessonInlineAdmin]


class UserAdmin(admin.ModelAdmin):
    list_display = ['pk', 'username']


class CategoryAdmin(admin.ModelAdmin):
    list_display = ['pk', 'name']
    search_fields = ['name']
    list_filter = ['id', 'name']


class VideoAdmin(admin.ModelAdmin):
    def save_model(self, request, obj, form, change):
        # Đặt giá trị url = None
        obj.url = None
        super().save_model(request, obj, form, change)

        # Kiểm tra và xử lý upload video
        if 'url' in request.FILES:
            video_file = request.FILES['url']
            temp_dir = '/app/temp_dir'  # Thay đổi đường dẫn tới thư mục tạm

            # Tạo thư mục tạm nếu chưa tồn tại
            if not os.path.exists(temp_dir):
                os.makedirs(temp_dir)

            # Lưu file tạm thời và gọi task Celery
            if isinstance(video_file, (InMemoryUploadedFile, TemporaryUploadedFile)):
                temp_file_path = os.path.join(temp_dir, video_file.name)
                with open(temp_file_path, 'wb') as temp_file:
                    for chunk in video_file.chunks():
                        temp_file.write(chunk)

                print(f"📂 File saved at: {temp_file_path}")  # Debug đường dẫn file

                # Kiểm tra file có tồn tại không
                print(f"📂 Files in {temp_dir}: {os.listdir(temp_dir)}")
                # Gửi task lên Celery để upload file lên S3
                upload_video_to_s3.delay(temp_file_path, video_file.name, obj.id)


admin_site.register(Video, VideoAdmin)
admin_site.register(Category)
admin_site.register(Course)
admin_site.register(Lesson)
admin_site.register(User)
admin_site.register(Payment)
admin_site.register(VideoTimeline)
