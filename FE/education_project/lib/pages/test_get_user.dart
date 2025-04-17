import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:education_project/features/login/presentation/provider/state/user_state.dart';
import 'package:education_project/features/login/presentation/provider/user_provider.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy trạng thái từ UserNotifier
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: _buildUserState(userState, ref),
      ),
    );
  }

  // Hàm build trạng thái dựa vào UserState
  Widget _buildUserState(UserState userState, WidgetRef ref) {
    if (userState is UserInit) {
      return ElevatedButton(
        onPressed: () {
          // Kích hoạt lấy thông tin người dùng
          ref.read(userNotifierProvider.notifier).getCurrentUser();
        },
        child: const Text('Fetch User Data'),
      );
    } else if (userState is UserLoading) {
      return const CircularProgressIndicator();
    } else if (userState is UserDone) {
      // Hiển thị thông tin người dùng nếu đã có
      return UserInfo(user: userState.user);
    } else if (userState is UserError) {
      return Text('Error: ${userState.error}');
    } else {
      return const Text('Unknown state');
    }
  }
}

// Widget hiển thị thông tin người dùng
class UserInfo extends StatelessWidget {
  final UserEntity? user;

  const UserInfo({super.key,  this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Name: ${user?.firstName}', style: const TextStyle(fontSize: 20)),
        Text('Name: ${user?.lastName}', style: const TextStyle(fontSize: 20)),

        Text('Email: ${user?.email}', style: const TextStyle(fontSize: 18)),
        Text('Phone: ${user?.phone}', style: const TextStyle(fontSize: 18)),
      ],
    );
  }
}
