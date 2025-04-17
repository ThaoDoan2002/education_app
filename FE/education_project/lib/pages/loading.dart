import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/home/presentation/provider/state/get_user_state.dart';
import '../features/home/presentation/provider/get_user_provider.dart';
import '../config/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends ConsumerStatefulWidget {
  const Loading({super.key});

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends ConsumerState<Loading> {
  void checkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isOnboardingCompleted = prefs.getBool('isOnboardingCompleted');
    final tokenStorage = TokenStorage();
    final token = await tokenStorage.getToken();

    await Future.delayed(Duration(seconds: 1));

    if (isOnboardingCompleted == false) {
      context.go('/languages');
    } else if (token != null && token.isNotEmpty) {
      context.go('/home'); // Đã có thông tin người dùng
    } else {
      // Chưa đăng nhập, chuyển tới trang welcome
      context.go('/welcome');
    }
  }

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
