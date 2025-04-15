import 'package:go_router/go_router.dart';

import '../../features/choose_language/presentation/pages/choose_language.dart';
import '../../features/forget_password/presentation/pages/forgot_password.dart';
import '../../features/forget_password/presentation/pages/reset_password.dart';
import '../../features/home/presentation/home.dart';
import '../../features/intro/presentation/pages/onboarding.dart';
import '../../features/login/presentation/pages/login.dart';
import '../../features/register/presentation/pages/register.dart';
import '../../features/welcome/presentation/pages/welcome.dart';
import '../../pages/home.dart';
import '../../pages/home_login.dart';
import '../../pages/loading.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/languages',
      builder: (context, state) => const ChooseLanguage(),
    ),
    GoRoute(
      path: '/boarding',
      builder: (context, state) => const Onboarding(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const Welcome(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => const ForgotPassword(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const Register(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Home(),
    ),

    GoRoute(
      path: '/reset-password',
      name: 'reset-password',
      builder: (context, state) {
        final uid = state.uri.queryParameters['uid']!;
        final token = state.uri.queryParameters['token']!;
        return ResetPasswordPage(uid: uid, token: token);
      },
    ),
  ],
);
