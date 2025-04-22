import 'package:education_project/config/routes/router_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/choose_language/presentation/pages/choose_language.dart';
import '../../features/forget_password/presentation/pages/forgot_password.dart';
import '../../features/forget_password/presentation/pages/reset_password.dart';
import '../../features/home/domain/entities/course.dart';
import '../../features/home/presentation/pages/home.dart';
import '../../features/intro/presentation/pages/onboarding.dart';
import '../../features/lesson/domain/entities/lesson.dart';
import '../../features/lesson/presentation/pages/lesson_screen.dart';
import '../../features/login/presentation/pages/login.dart';
import '../../features/profile/presentation/pages/profile.dart';
import '../../features/register/presentation/pages/register.dart';
import '../../features/video/domain/entity/video.dart';
import '../../features/video/presentation/pages/video_page.dart';
import '../../features/welcome/presentation/pages/welcome.dart';
import '../../features/courses/presentation/pages/courses.dart';
import '../../features/courses/presentation/pages/widget/web_view_screen.dart';
import '../../main_layout.dart';
import '../../pages/loading.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.root,
  routes: [
    // Routes không cần layout chính
    GoRoute(path: RoutePaths.root, builder: (context, state) => const Loading()),
    GoRoute(path: RoutePaths.languages, builder: (context, state) => const ChooseLanguage()),
    GoRoute(path: RoutePaths.onboarding, builder: (context, state) => const Onboarding()),
    GoRoute(path: RoutePaths.welcome, builder: (context, state) => const Welcome()),
    GoRoute(path: RoutePaths.login, builder: (context, state) => const Login()),
    GoRoute(path: RoutePaths.register, builder: (context, state) => const Register()),
    GoRoute(path: RoutePaths.forgotPassword, builder: (context, state) => const ForgotPassword()),
    GoRoute(
      path: RoutePaths.resetPassword,
      name: RouteNames.resetPassword,
      builder: (context, state) {
        final uid = state.uri.queryParameters['uid'] ?? '';
        final token = state.uri.queryParameters['token'] ?? '';
        if (uid.isEmpty || token.isEmpty) {
          return const Scaffold(body: Center(child: Text('Liên kết không hợp lệ')));
        }
        return ResetPasswordPage(uid: uid, token: token);
      },
    ),
    GoRoute(
      path: RoutePaths.checkout,
      name: RouteNames.checkout,
      builder: (context, state) {
        final url = state.uri.queryParameters['checkout_url'] ?? '';
        final id = state.uri.queryParameters['id'] ?? '';
        if (url.isEmpty || id.isEmpty) {
          return const Scaffold(body: Center(child: Text('Không có thông tin thanh toán')));
        }
        return WebViewScreen(checkoutUrl: url, catId: id);
      },
    ),
    GoRoute(
      path: RoutePaths.lessons,
      name: RouteNames.lessons,
      builder: (context, state) {
        final course = state.extra as CourseEntity?;
        if (course == null) {
          return const Scaffold(body: Center(child: Text('Không có dữ liệu khóa học')));
        }
        return LessonScreen(course: course);
      },
    ),
    GoRoute(
      path: RoutePaths.video,
      name: RouteNames.video,
      builder: (context, state) {
        if (state.extra is Map<String, Object>) {
          final data = state.extra as Map<String, Object>;
          final lesson = data['lesson'] as LessonEntity?;
          final video = data['video'] as VideoEntity?;
          if (lesson != null && video != null) {
            return VideoScreen(lesson: lesson, video: video);
          }
        }
        return const Scaffold(body: Center(child: Text('Không có dữ liệu video')));
      },
    ),

    // 🔥 ShellRoute cho các trang chính
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: RoutePaths.home,
          builder: (context, state) => Home(),
        ),
        GoRoute(
          path: RoutePaths.courses,
          builder: (context, state) => const CoursesScreen(),
        ),
        GoRoute(
          path: RoutePaths.profile,
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
  ],
);
