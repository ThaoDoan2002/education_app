import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPage({super.key, required this.controller});

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage> {
  @override
  void initState() {
    super.initState();

    // Wait for the first frame to be rendered before changing orientation
    // Chờ 1 giây trước khi thực hiện xoay ngang
    Future.delayed(const Duration(milliseconds: 150), () {
      // Ép xoay ngang khi vào trang full màn hình
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // Ẩn thanh điều hướng và status bar
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });  }

  @override
  void dispose() {
    super.dispose();
    // Đảm bảo gọi `SystemChrome.setPreferredOrientations` khi người dùng thoát khỏi fullscreen
    Future.delayed(const Duration(milliseconds: 200), () {
      // Quay lại chế độ dọc sau khi thoát fullscreen
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      // Hiện lại thanh điều hướng và status bar khi thoát fullscreen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          ),
          // Nút thu nhỏ để thoát fullscreen
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.fullscreen_exit,
                    color: Colors.white, size: 30),
                onPressed: () async {
                  // Quay về chế độ dọc trước khi pop màn hình
                  await _exitFullScreen();
                  Navigator.pop(context); // Quay lại trang trước
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm xử lý việc thoát fullscreen và quay lại chế độ dọc
  Future<void> _exitFullScreen() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    await Future.delayed(
        const Duration(milliseconds: 200)); // Chờ một chút để xử lý
  }
}
