import stripe
from django.urls import path, include
from rest_framework import routers
from courses import views
from .stripe_utils import StripeCheckoutViewSet,stripe_webhook
from .views import SendOtpView, VerifyOtpView, RegisterView

router = routers.DefaultRouter()
router.register('categories', views.CategoryViewSet, basename='categories')
router.register('courses', views.CourseViewSet, basename='courses')
router.register('lessons', views.LessonViewSet, basename='lessons')
router.register('users', views.UserViewSet, basename='users')
router.register('videos', views.VideoViewSet, basename='videos')
router.register('payments', StripeCheckoutViewSet, basename='payments')
router.register('social_login', views.FirebaseLoginViewSet, basename='social_login')
router.register('request-reset-password', views.ResetPasswordRequestViewSet, basename='request-reset-password')
router.register('reset-password', views.ResetPasswordConfirmViewSet, basename='reset-password')
router.register('save-device-token', views.SaveDeviceTokenView, basename='save-device-token')
router.register('notes', views.NoteViewSet, basename='notes')
router.register('send-otp', views.SendOtpView, basename='send-otp')
router.register('verify-otp', views.VerifyOtpView, basename='verify-otp')
router.register('register-info', views.RegisterView, basename='register-info')
router.register('tts', views.TextToSpeechViewSet, basename='tts')






urlpatterns = [
    path('', include(router.urls)),
    path('success/', views.successed, name="success"),
    path('cancel/', views.cancelled, name="cancel"),
    path('webGoHooks/', stripe_webhook, name='stripe_webhook'),

]
