import 'package:education_project/features/home/presentation/provider/get_cates_provider.dart';
import 'package:education_project/features/home/presentation/provider/get_courses_by_cate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return categories.when(
      data: (cats) => DefaultTabController(
        length: cats.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            centerTitle: true,
            title: const Text(
              'Danh sách khoá học',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              TabBar(
                isScrollable: true,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12),
                ),
                dividerColor: Colors.transparent,
                tabs: cats.map((cat) {
                  return Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        cat.name,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Container(
                  color: Colors.grey[100],
                  child: TabBarView(
                    children: cats.map((cat) {
                      final courses = ref.watch(coursesByCateProvider(cat.id));
                      return courses.when(
                        data: (courseList) => SingleChildScrollView(
                          child: Column(
                            children: courseList.map((course) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(16)),
                                            child: Image.network(
                                              '$CLOUDINARY_URL${course.thumbnail}' ??
                                                  '',
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 4, 8, 4),
                                            child: Text(
                                              course.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 4),
                                            child: Row(
                                              children: [
                                                Icon(Icons.school_outlined,
                                                    color: Colors.blue.shade300,
                                                    size: 20),
                                                const SizedBox(width: 5),
                                                Text(
                                                  course.description ??
                                                      'Unknown',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                              thickness: 1,
                                              indent: 5,
                                              endIndent: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${NumberFormat('#,###', 'vi_VN').format(course.price)} VND',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 21),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  print('Thanh toán');
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFFE0F2FF),
                                                  foregroundColor: Colors.blue,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Thanh toán',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text('Lỗi: $err')),
                      );
                    }).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text("Lỗi: $err")),
    );
  }
}
