import 'package:education_project/config/storage/token_storage.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../features/login/presentation/provider/login_provider.dart';
import '../features/login/presentation/provider/state/login_state.dart';
import '../features/login/presentation/provider/user_provider.dart';

class LoginScreen extends ConsumerWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenStorage = ref.read(tokenStorageProvider);
    // Lấy trạng thái từ LoginState và loginNotifier từ Riverpod
    final loginState = ref.watch(loginNotifierProvider);
    final loginNotifier = ref.read(loginNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            // Hiển thị lỗi nếu có


            // Hiển thị vòng tròn loading khi đang xử lý
            loginState is LoginLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      // Tạo LoginParams từ dữ liệu nhập vào
                      LoginBodyParams params = LoginBodyParams(
                        username: _usernameController.text,
                        password: _passwordController.text,
                      );

                      // Gọi phương thức login
                      await loginNotifier.login(params);

                      // Sau khi đăng nhập thành công, lấy token lưu trong storage
                      await tokenStorage.getToken().then((token){
                        print('Token từ storage: $token');
                      });


                    },
                    child: const Text('Đăng nhập'),
                  ),
          ],
        ),
      ),
    );
  }
}
