import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';
import 'package:education_project/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../home/presentation/provider/get_user_provider.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUpdatingAvatar = false;

  Future<bool> updateAvatarWithDio(File file) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(file.path),
      });

      final dio = Dio();
      final token = await TokenStorage().getAccessToken();

      final response = await dio.patch(
        '$BASE_URL/users/edit-avatar/', // thay bằng URL thực tế
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // thêm token nếu cần
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi cập nhật avatar: $e");
      return false;
    }
  }

  Future<void> _onEditAvatar() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _isUpdatingAvatar = true;
      });

      final file = File(picked.path);
      final result = await updateAvatarWithDio(file);

      if (!mounted) return;

      setState(() {
        _isUpdatingAvatar = false;
      });

      if (result) {
        ref.invalidate(userProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật avatar thành công")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật avatar thất bại")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Tài khoản', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: userAsync.when(
        data: (user) => Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top:10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  backgroundImage: user?.avatar != null && user!.avatar!.isNotEmpty
                                      ? NetworkImage('$CLOUDINARY_URL${user?.avatar!}')
                                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                                  radius: 50,
                                ),
                              ),
                              if (_isUpdatingAvatar)
                                const Positioned.fill(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _onEditAvatar,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blueAccent,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${user?.lastName} ${user?.firstName}'.trim().isNotEmpty
                                ? '${user?.lastName} ${user?.firstName}'
                                : '${user?.username}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(user?.email ?? 'Chưa có email'),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.push('/edit-profile');
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Sửa thông tin'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await TokenStorage().clearTokens();
                  if (!mounted) return;
                  ref.read(tokenProvider.notifier).state = null;
                  context.go('/welcome'); // hoặc route đăng nhập của bạn
                },
                icon: const Icon(Icons.logout),
                label: const Text('Đăng xuất'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi: $err')),
      ),
    );
  }
}
