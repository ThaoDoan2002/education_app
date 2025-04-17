import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'full_screen.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isBuffering = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://www.w3schools.com/html/mov_bbb.mp4'),
    )..initialize().then((_) {
      setState(() {});
    });

    _controller.addListener(() {
      final isBuffering = _controller.value.isBuffering;
      final isPlaying = _controller.value.isPlaying;
      final isEnded = _controller.value.position >= _controller.value.duration;

      if (isEnded) {
        _controller.pause();
        setState(() {
          _isPlaying = false;
        });
      }

      if (isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }

      if (isBuffering != _isBuffering) {
        setState(() {
          _isBuffering = isBuffering;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _goFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenVideoPage(controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),

                if (_isBuffering)
                  const CircularProgressIndicator(),

                // Nút fullscreen ở góc phải dưới
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white, size: 30),
                    onPressed: _goFullScreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10, size: 40),
                  onPressed: () {
                    final current = _controller.value.position;
                    final newPosition = current - const Duration(seconds: 10);
                    _controller.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
                  },
                ),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                  onPressed: _togglePlayPause,
                ),
                IconButton(
                  icon: const Icon(Icons.forward_10, size: 40),
                  onPressed: () {
                    final current = _controller.value.position;
                    final duration = _controller.value.duration;
                    final newPosition = current + const Duration(seconds: 10);
                    _controller.seekTo(newPosition > duration ? duration : newPosition);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}