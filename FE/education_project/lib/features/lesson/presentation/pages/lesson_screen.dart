import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/presentation/provider/get_own_course_by_cate_provider.dart';
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

class _LessonScreenState extends ConsumerState<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    final lessonsPro = ref.watch(lessonsProvider(widget.course.id));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFF0E0),
        surfaceTintColor: Color(0xFFFFE5CC),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15, left: 8.0, right: 8.0),
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
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade200,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    title: Text(
                      lessons[index].title,
                      // Assuming each lesson has a 'name' property
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
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
                      }
                  ),
                );
              },
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, stack) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
