import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/constants.dart';
import '../../home/presentation/provider/get_own_course_by_cate_provider.dart';

class MyCoursesScreen extends ConsumerStatefulWidget {
  final int cateID;
  const MyCoursesScreen({super.key, required this.cateID});

  @override
  ConsumerState<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends ConsumerState<MyCoursesScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(coursesOwnByCateProvider(widget.cateID));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Khoá học của tôi',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: courses.when(
        data: (courseList) {
          return ListView.builder(
            itemCount: courseList!.length,
            itemBuilder: (context, index) {
              final course = courseList[index];

              final Animation<double> fadeAnimation = CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  0.1 * index,
                  0.1 * index + 0.6,
                  curve: Curves.easeOut,
                ),
              );

              final Animation<Offset> slideAnimation = Tween<Offset>(
                begin: const Offset(0.4, 0), // xuất hiện từ phải
                end: Offset.zero,
              ).animate(fadeAnimation);

              return FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InkWell(
                      onTap: () {
                        context.push(
                          '/lessons',
                          extra: course,
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  '$CLOUDINARY_URL${course.thumbnail}',
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                child: Text(
                                  course.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, right: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.school_outlined, color: Colors.blue.shade300, size: 20),
                                    const SizedBox(width: 5),
                                    Text(
                                      course.description ?? 'Unknown',
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        error: (err, _) => Center(child: Text("Lỗi: $err")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
