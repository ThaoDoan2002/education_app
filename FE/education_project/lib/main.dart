import 'package:education_project/features/choose_language/presentation/pages/choose_language.dart';
import 'package:education_project/features/forget_password/presentation/pages/forgot_password.dart';
import 'package:education_project/features/register/presentation/pages/register.dart';
import 'package:education_project/pages/home.dart';
import 'package:education_project/pages/home_login.dart';
import 'package:education_project/pages/loading.dart';
import 'package:education_project/pages/sign_up/sign_up.dart';
import 'package:education_project/features/welcome/presentation/pages/welcome.dart';
import 'package:education_project/features/choose_language/presentation/provider/locale_provider.dart';
import 'package:education_project/pages/test_get_user.dart';
import 'package:education_project/pages/test_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/routes/app_routers.dart';
import 'features/intro/presentation/pages/onboarding.dart';
import 'features/login/presentation/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    return MaterialApp.router(
      routerConfig: appRouter,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('vi'),
      ],
      locale: locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
