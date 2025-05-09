import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({required this.child});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0; // Biến trạng thái để theo dõi mục được chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Cập nhật màu sắc dựa trên chỉ mục
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.houseUser), label: 'Trang chủ'),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.book), label: 'Khoá học'),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: 'Hồ sơ'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Cập nhật trạng thái chỉ mục khi nhấn
          });
          // Chuyển hướng đến các trang tương ứng
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/courses');
          if (index == 2) context.go('/profile');
        },
      ),
    );
  }
}
