from django.db import models
from django.contrib.auth.models import AbstractUser
from cloudinary.models import CloudinaryField
from .validators import file_size
from django.dispatch import receiver
from django.db.models.signals import post_save


class User(AbstractUser):
    avatar = CloudinaryField('avatar', null=True, blank=True)
    phone = models.CharField(max_length=255, unique=True,null=True,blank=True,)
    email = models.EmailField(unique=True, blank=True, null=True)
    firebase_uid = models.CharField(max_length=128, unique=True, null=True, blank=True)


class Category(models.Model):
    name = models.CharField(max_length=255)

    def __str__(self):
        return self.name


class BaseModel(models.Model):
    created_date = models.DateField(auto_now_add=True, null=True)
    updated_date = models.DateField(auto_now=True, null=True)
    active = models.BooleanField(default=True)

    class Meta:
        abstract = True


class Course(BaseModel):
    name = models.CharField(max_length=255, null=False, unique=True)
    description = models.TextField(null=True, blank=True, max_length=255)
    thumbnail = CloudinaryField('thumbnail')
    price = models.IntegerField()
    category = models.ForeignKey(Category, on_delete=models.RESTRICT)

    class Meta:
        unique_together = ('name', 'category')

    def __str__(self):
        return self.name


class Lesson(BaseModel):
    title = models.CharField(max_length=255, null=False)
    description = models.TextField(null=True, blank=True, max_length=255)
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name='lessons')

    class Meta:
        unique_together = ('title', 'course')

    def __str__(self):
        return self.title + " - " + self.course.name


class Video(BaseModel):
    thumbnail = CloudinaryField('thumbnail')
    url = models.FileField(upload_to='courses/%Y/%m', validators=[file_size])
    lesson = models.OneToOneField(Lesson, on_delete=models.CASCADE, related_name='video')

class VideoTimeline(models.Model):
    video = models.ForeignKey(Video, on_delete=models.CASCADE, related_name='timelines')
    time_in_seconds = models.PositiveIntegerField(help_text="Time in seconds for the timeline mark.")
    description = models.TextField(help_text="Description of the timeline point.")
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['time_in_seconds']




class Note(BaseModel):
    content = models.TextField(max_length=255)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    video = models.ForeignKey(Video, on_delete=models.CASCADE, related_name='notes')
    timestamp = models.FloatField()


class Payment(BaseModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    course = models.ForeignKey(Course, on_delete=models.CASCADE, null=True)
    status = models.BooleanField(default=False)

    class Meta:
        unique_together = ('user', 'course')


class DeviceToken(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True)
    token = models.CharField(max_length=255, unique=True)
    platform = models.CharField(max_length=10, choices=[('android', 'Android'), ('ios', 'iOS')])
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


