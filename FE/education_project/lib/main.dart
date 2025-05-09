
import 'package:education_project/core/utils/firebase_message.dart';
import 'package:education_project/core/utils/injection_container.dart';
import 'package:education_project/features/choose_language/presentation/provider/locale_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/routes/app_routers.dart';

void main() async {
  // Đảm bảo Flutter binding đã được khởi tạo trước khi gọi bất kỳ phương thức nào
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Đăng ký handler cho thông báo nền
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseApi().initNotification();
  // Dependency Injection
  await initializeDependencies();
  runApp(const ProviderScope(child: MyApp()));
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Đảm bảo xử lý thông báo ở nền
  print("Handling a background message: ${message.messageId}");
  // Xử lý thông báo ở đây, ví dụ: hiển thị thông báo hoặc cập nhật UI
}
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      routerConfig: appRouter,
      localizationsDelegates: const [
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
