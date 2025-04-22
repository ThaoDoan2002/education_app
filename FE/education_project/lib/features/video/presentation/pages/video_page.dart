import 'package:education_project/core/constants/constants.dart';
import 'package:education_project/features/lesson/domain/entities/lesson.dart';
import 'package:education_project/features/video/domain/entity/note.dart';
import 'package:education_project/features/video/domain/entity/timeline.dart';
import 'package:education_project/features/video/domain/entity/video.dart';
import 'package:education_project/features/video/presentation/provider/state/note_state.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import '../../domain/usecase/params/note_params.dart';
import '../provider/note_provider.dart';

class VideoScreen extends ConsumerStatefulWidget {
  final LessonEntity lesson;
  final VideoEntity video;

  const VideoScreen({super.key, required this.lesson, required this.video});

  @override
  ConsumerState createState() => _VideoScreenState();
}

class _VideoScreenState extends ConsumerState<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  bool _isExpanded = false;
  bool _isNotesExpanded = false;
  ChewieController? _chewieController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.video.url),
    );

    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      _chewieController = ChewieController(
        customControls: CustomVideoControls(
          videoID: widget.video.id,
        ),
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        showControls: true,
        allowFullScreen: true,
        allowPlaybackSpeedChanging: true,
      );
      setState(() {});
    });
  }

  void _showNoteDialog(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    final TextEditingController timeController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Note and Video Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: noteController,
                decoration: InputDecoration(labelText: 'Enter your note'),
              ),
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: 'Enter video time (in seconds)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final String note = noteController.text;
                final String time = timeController.text;

                if (note.isNotEmpty && time.isNotEmpty) {
                  // Xử lý ghi chú và thời gian
                  debugPrint('Note: $note');
                  debugPrint('Video time: $time');
                }

                Navigator.of(context).pop(); // Đóng dialog sau khi lưu
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog nếu nhấn Cancel
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final List<TimelineEntity> timestamps = widget.video.timelines;
    final notesAsyncValue = ref.watch(notesProvider(widget.video.id));
    List<NoteEntity>? notes = notesAsyncValue.value;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lesson.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey.withOpacity(0.4),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              final aspectRatio = _videoPlayerController.value.isInitialized
                  ? _videoPlayerController.value.aspectRatio
                  : 16 / 9;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: aspectRatio,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (widget.video.thumbnail != null)
                                Positioned.fill(
                                  child: Image.network(
                                    '$CLOUDINARY_URL${widget.video.thumbnail!}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              const CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Lỗi khi tải video'));
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Chewie(controller: _chewieController!),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // ExpansionTile widget for showing and hiding the timeline
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          "Nội dung bài học",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        trailing: Icon(
                          _isExpanded
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        tilePadding:
                            EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        // Điều chỉnh khoảng cách trong ExpansionTile
                
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _isExpanded =
                                expanded; // Handle the expanded state change
                          });
                        },
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: timestamps.length,
                            itemBuilder: (context, index) {
                              final timestamp = timestamps[index];
                              return ListTile(
                                title: Text(timestamp.description),
                                trailing: Text(
                                  _formatDuration(
                                      Duration(seconds: timestamp.time)),
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  _videoPlayerController
                                      .seekTo(Duration(seconds: timestamp.time));
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // ExpansionTile widget for showing and hiding the notes
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          "Ghi chú của bạn",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        trailing: Icon(
                          _isNotesExpanded
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            _isNotesExpanded =
                                expanded; // Handle the expanded state change for notes
                          });
                        },
                        children: [
                          // Use a Container with a fixed height or a Flexible to allow scrolling
                          Container(
                            height: _isNotesExpanded ? 200 : 0,
                            // Adjust height based on expansion state
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: notes?.length,
                                itemBuilder: (context, index) {
                                  final note = notes?[index];
                                  return ListTile(
                                    leading: Icon(Icons.sticky_note_2_outlined,
                                        color: Colors.orange),
                                    title: Text(note!.content),
                                    subtitle: Text(
                                        "🕒 ${_formatDuration(Duration(seconds: note.timestamp.toInt()))}"),
                                    onTap: () {
                                      _videoPlayerController.seekTo(
                                        Duration(seconds: note!.timestamp.toInt()),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

// Timeline model đơn giản

class CustomVideoControls extends ConsumerWidget {
  final int videoID;

  const CustomVideoControls({super.key, required this.videoID});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chewieController = ChewieController.of(context);
    final videoController = chewieController.videoPlayerController;
    final notesAsyncValue = ref.watch(notesProvider(videoID));

    return Stack(
      children: [
        const MaterialControls(), // Controls mặc định
        Positioned(
          top: 2,
          right: 24,
          child: IconButton(
            icon: const Icon(Icons.note_add, color: Colors.white, size: 24),
            onPressed: () async {
              final currentTime = videoController.value.position.inSeconds;

              // Tạm dừng video
              videoController.pause();

              if (notesAsyncValue is AsyncData<List<NoteEntity>>) {
                final notesList = notesAsyncValue.value;

                // Tìm note có timestamp = currentTime
                final existingNote = notesList
                    .where((note) => note.timestamp == currentTime)
                    .toList()
                    .cast<NoteEntity?>()
                    .firstOrNull;

                final noteController = TextEditingController(
                  text: existingNote?.content ?? '',
                );

                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Ghi chú tại ${_formatTime(currentTime)}',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    content: TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Nội dung ghi chú...",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    actionsPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Huỷ"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final content = noteController.text;
                          if (content.isNotEmpty) {
                            final noteParams = NoteBodyParams(
                              videoID: videoID,
                              content: content,
                              timestamp: currentTime,
                            );

                            await ref
                                .read(noteNotifierProvider.notifier)
                                .createNote(noteParams);

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Đã lưu ghi chú")),
                            );
                          }
                        },
                        child: const Text("Lưu"),
                      ),
                    ],
                  ),
                );

                // Phát video lại sau khi đóng dialog
                videoController.play();
              } else if (notesAsyncValue is AsyncError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Lỗi khi tải ghi chú")),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final sec = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }
}
