import 'package:dio/dio.dart';
import 'package:education_project/features/courses/data/repository_impl/checkout_repository_impl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../config/storage/auth_interceptor.dart';
import '../../config/storage/token_storage.dart';
import '../../features/courses/data/data_sources/checkout_api_service.dart';
import '../../features/courses/domain/repository/checkout_repository.dart';
import '../../features/courses/domain/usecases/checkout.dart';
import '../../features/forget_password/data/data_sources/forgot_password_api_service.dart';
import '../../features/forget_password/data/repository_impl/forgot_password_repository_impl.dart';
import '../../features/forget_password/domain/repository/forgot_password_repository.dart';
import '../../features/forget_password/domain/usecases/forget_password.dart';
import '../../features/forget_password/domain/usecases/reset_password.dart';
import '../../features/home/data/data_sources/cate_api_service.dart';
import '../../features/home/data/data_sources/courses_api_service.dart';
import '../../features/home/data/data_sources/user_info_api_service.dart';
import '../../features/home/data/repository_impl/cate_repository_impl.dart';
import '../../features/home/data/repository_impl/course_repository_impl.dart';
import '../../features/home/data/repository_impl/user_info_repository_impl.dart';
import '../../features/home/domain/repository/cate_repository.dart';
import '../../features/home/domain/repository/course_repository.dart';
import '../../features/home/domain/repository/user_info_repository.dart';
import '../../features/home/domain/usecases/get_cate_by_id.dart';
import '../../features/home/domain/usecases/get_cates.dart';
import '../../features/home/domain/usecases/get_courses_by_cate.dart';
import '../../features/home/domain/usecases/get_own_courses.dart';
import '../../features/home/domain/usecases/get_own_courses_by_cate.dart';
import '../../features/home/domain/usecases/get_user.dart';
import '../../features/lesson/data/data_sources/lesson_api_service.dart';
import '../../features/lesson/data/repository_impl/lesson_repository_impl.dart';
import '../../features/lesson/domain/repository/lesson_repository.dart';
import '../../features/lesson/domain/usecase/get_lesson.dart';
import '../../features/login/data/data_sources/auth_api_service.dart';
import '../../features/login/data/data_sources/social_auth_api_service.dart';
import '../../features/login/data/data_sources/user_api_service.dart';
import '../../features/login/data/repository_impl/auth_repository_impl.dart';
import '../../features/login/data/repository_impl/social_auth_repository_impl.dart';
import '../../features/login/data/repository_impl/user_repository_impl.dart';
import '../../features/login/domain/repository/auth_repository.dart';
import '../../features/login/domain/repository/social_auth_repository.dart';
import '../../features/login/domain/repository/user_repository.dart';
import '../../features/login/domain/usecases/get_current_user.dart';
import '../../features/login/domain/usecases/login.dart';
import '../../features/login/domain/usecases/social_login.dart';
import '../../features/register/data/data_sources/register_api_service.dart';
import '../../features/register/data/repository_impl/register_repository_impl.dart';
import '../../features/register/domain/repository/register_repository.dart';
import '../../features/register/domain/usecases/register.dart';
import '../../features/video/data/data_sources/note_api_service.dart';
import '../../features/video/data/data_sources/video_api_service.dart';
import '../../features/video/data/repository_impl/note_repository_impl.dart';
import '../../features/video/data/repository_impl/video_repository_impl.dart';
import '../../features/video/domain/repository/note_repository.dart';
import '../../features/video/domain/repository/video_repository.dart';
import '../../features/video/domain/usecase/delete_note.dart';
import '../../features/video/domain/usecase/get_notes_by_video.dart';
import '../../features/video/domain/usecase/note.dart';
import '../../features/video/domain/usecase/video.dart';

final s1 = GetIt.instance;

Future<void> initializeDependencies() async {
  final dio = Dio();
  dio.interceptors.add(AuthInterceptor(dio, TokenStorage()));
  s1.registerSingleton<Dio>(dio);

  // TokenStorage
  s1.registerSingleton<TokenStorage>(TokenStorage());

  // Checkout API
  s1.registerSingleton<CheckoutApiService>(CheckoutApiService(s1()));
  s1.registerSingleton<CheckoutRepository>(CheckoutRepositoryImpl(s1()));
  s1.registerSingleton<CheckoutUseCase>(CheckoutUseCase(s1()));

  // Forgot Password
  s1.registerSingleton<ForgotPasswordAPIService>(ForgotPasswordAPIService(s1()));
  s1.registerSingleton<ForgotPasswordRepository>(ForgotPasswordRepositoryImpl(s1()));
  s1.registerSingleton<ForgetPasswordUseCase>(ForgetPasswordUseCase(s1()));
  s1.registerSingleton<ResetPasswordUseCase>(ResetPasswordUseCase(s1()));

  // Home
  s1.registerSingleton<CateApiService>(CateApiService(s1()));
  s1.registerSingleton<CoursesApiService>(CoursesApiService(s1()));
  s1.registerSingleton<UserInfoApiService>(UserInfoApiService(s1()));
  s1.registerSingleton<CateRepository>(CateRepositoryImpl(s1()));
  s1.registerSingleton<CourseRepository>(CourseRepositoryImpl(s1()));
  s1.registerSingleton<UserInfoRepository>(UserInfoRepositoryImpl(s1()));
  s1.registerSingleton<GetCateByIdUseCase>(GetCateByIdUseCase(s1()));
  s1.registerSingleton<GetCatesUseCase>(GetCatesUseCase(s1()));
  s1.registerSingleton<GetCoursesByCateUseCase>(GetCoursesByCateUseCase(s1()));
  s1.registerSingleton<GetOwnCoursesUseCase>(GetOwnCoursesUseCase(s1()));
  s1.registerSingleton<GetOwnCoursesByCateUseCase>(GetOwnCoursesByCateUseCase(s1()));
  s1.registerSingleton<GetUserUseCase>(GetUserUseCase(s1()));

  // Lesson
  s1.registerSingleton<LessonApiService>(LessonApiService(s1()));
  s1.registerSingleton<LessonRepository>(LessonRepositoryImpl(s1()));
  s1.registerSingleton<GetLessonsUseCase>(GetLessonsUseCase(s1()));

  // Login
  s1.registerSingleton<AuthAPIService>(AuthAPIService(s1()));
  s1.registerSingleton<SocialAuthAPIService>(SocialAuthAPIService(s1()));
  s1.registerSingleton<UserApiService>(UserApiService(s1()));
  s1.registerSingleton<AuthRepository>(AuthRepositoryImpl(s1()));
  s1.registerSingleton<SocialAuthRepository>(SocialAuthRepositoryImpl(s1()));
  s1.registerSingleton<UserRepository>(UserRepositoryImpl(s1()));
  s1.registerSingleton<GetCurrentUserUseCase>(GetCurrentUserUseCase(s1()));
  s1.registerSingleton<LoginUseCase>(LoginUseCase(s1()));
  s1.registerSingleton<SocialLoginUseCase>(SocialLoginUseCase(s1()));

  // Register
  s1.registerSingleton<RegisterAPIService>(RegisterAPIService(s1()));
  s1.registerSingleton<RegisterRepository>(RegisterRepositoryImpl(s1()));
  s1.registerSingleton<RegisterUseCase>(RegisterUseCase(s1()));

  // Video
  s1.registerSingleton<NoteApiService>(NoteApiService(s1()));
  s1.registerSingleton<VideoApiService>(VideoApiService(s1()));
  s1.registerSingleton<NoteRepository>(NoteRepositoryImpl(s1()));
  s1.registerSingleton<VideoRepository>(VideoRepositoryImpl(s1()));
  s1.registerSingleton<DeleteNoteUseCase>(DeleteNoteUseCase(s1()));
  s1.registerSingleton<GetNotesByVideoUseCase>(GetNotesByVideoUseCase(s1()));
  s1.registerSingleton<NoteUseCase>(NoteUseCase(s1()));
  s1.registerSingleton<VideoUseCase>(VideoUseCase(s1()));
}
