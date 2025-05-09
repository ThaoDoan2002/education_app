import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/lesson/presentation/provider/lesson_provider.dart';
import 'package:education_project/features/video/presentation/provider/video_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final CourseEntity course;

  const LessonScreen({super.key, required this.course});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonsPro = ref.watch(lessonsProvider(widget.course.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF0E0),
        surfaceTintColor: const Color(0xFFFFE5CC),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15, left: 8.0, right: 8.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF0E0),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: lessonsPro.when(
          data: (lessons) {
            return ListView.builder(
              itemCount: lessons?.length ?? 0,
              itemBuilder: (context, index) {
                final Animation<double> fadeAnimation = CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.1 * index,
                    0.1 * index + 0.6,
                    curve: Curves.easeOut,
                  ),
                );

                final Animation<Offset> slideAnimation = Tween<Offset>(
                  begin: const Offset(0.4, 0), // Từ phải qua
                  end: Offset.zero,
                ).animate(fadeAnimation);

                return FadeTransition(
                  opacity: fadeAnimation,
                  child: SlideTransition(
                    position: slideAnimation,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange.shade200,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        title: Text(
                          lessons![index].title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          try {
                            final video = await ref.read(videoProvider(lessons[index].id).future);

                            context.push(
                              '/video',
                              extra: {
                                'lesson': lessons[index],
                                'video': video,
                              },
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Không thể tải video: $e')),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, stack) => Center(child: Text('Lỗi: $e')),
        ),
      ),
    );
  }
}
