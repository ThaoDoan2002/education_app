import 'package:education_project/config/routes/app_routers.dart';
import 'package:education_project/core/constants/constants.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/presentation/provider/get_cate_by_ID_provider.dart';
import 'package:education_project/features/home/presentation/provider/get_own_course_by_cate_provider.dart';
import 'package:education_project/features/home/presentation/provider/get_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'bottom_sheet_cate.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int selectedID = 1;
  late CategoryEntity cateSelected;
  final List<String> imageList = [
    'assets/home/slide_1.jpg',
    'assets/home/slide_2.jpg',
    'assets/home/slide_3.jpg',
  ];

  int _selectedIndex = 0;  // Lưu trữ index được chọn của BottomNavigationBar

  void showCateSelectionModal() async {
    // Hiển thị modal và chờ kết quả (danh mục đã chọn)
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BottomSheetCate(
        selectedId: selectedID,
      ),
    );
    print(result);
    if (result != 0 && result != null) {
      setState(() {
        selectedID = result!;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Điều hướng đến các trang khác nếu cần
    if (index == 1) {
      context.push('/courses');
    } else if (index == 2) {
      context.push('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final cateById = ref.watch(categoryProvider(selectedID));
    final courses = ref.watch(coursesOwnByCateProvider(selectedID));
    return Scaffold(
      backgroundColor: Color(0xFFDAF3FF), // Xanh nhạt
      appBar: AppBar(
        backgroundColor: Color(0xFFDAF3FF),
        surfaceTintColor: Color(0xFFDAF3FF),
        toolbarHeight: 85,
        title: GestureDetector(
          onTap: () {
            showCateSelectionModal();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              user.when(
                data: (u) {
                  return Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 28.0,
                          backgroundImage: u.avatar != null
                              ? NetworkImage(u.avatar!)
                              : const AssetImage('assets/home/user.png')
                          as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xin chào, ${u.lastName} ${u.firstName}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          cateById.when(
                            data: (c) {
                              if (c == null) {
                                return const Text('Không có dữ liệu');
                              }
                              return Column(
                                children: [
                                  Text(
                                    'Bạn đang học ${c.name}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              );
                            },
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stackTrace) => Text('Lỗi: $error'),
                          )
                        ],
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => const Text('Có lỗi xảy ra'),
              ),
              const Icon(Icons.arrow_drop_down, size: 50),
            ],
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFDAF3FF),
              Color(0xFFEFFEFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    aspectRatio: 16 / 9,
                  ),
                  items: imageList
                      .map((item) => Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        item,
                        fit: BoxFit.cover,
                        width: 1000,
                      ),
                    ),
                  ))
                      .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Khám phá',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context.push('/courses');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.my_library_books_outlined,
                                    color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Các khoá học',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.diamond_outlined,
                                    color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Khoá học của tôi',
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, left: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khoá học của tôi',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          SizedBox(
                            height: 300,
                            child: courses.when(
                              data: (c) {
                                if (c.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      'Không có khóa học nào',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: c.length,
                                  itemBuilder: (context, index) {
                                    final course = c[index];
                                    return Padding(
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
                                          width: 300,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(16),
                                            border: Border.all(
                                                color: Colors.white, width: 1),
                                            boxShadow: [
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
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(16)),
                                                  child: Image.network(
                                                    '$CLOUDINARY_URL${course.thumbnail}',
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
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 22,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5, right: 4),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.school_outlined,
                                                        color: Colors
                                                            .blue.shade300,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        course.description,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                        maxLines: 2,
                                                        overflow:
                                                        TextOverflow.ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              loading: () => Center(),
                              error: (err, stack) {
                                return const Text('Có lỗi xảy ra');
                              },
                            ),
                          )
                        ])),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
