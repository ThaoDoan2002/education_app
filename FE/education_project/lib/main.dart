import 'package:education_project/pages/choose_language.dart';
import 'package:education_project/pages/home.dart';
import 'package:education_project/pages/loading.dart';
import 'package:education_project/pages/intro/onboarding.dart';
import 'package:education_project/pages/login/login.dart';
import 'package:education_project/pages/welcome.dart';
import 'package:education_project/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    return MaterialApp(
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
      initialRoute: '/',
      routes: {
        '/': (context) => const Loading(),
        '/languages': (context) => const ChooseLanguage(),
        '/boarding': (context) => const Onboarding(),
        '/welcome': (context) => const Welcome(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),

      },
    );
  }
}
