import 'package:education_project/features/home/presentation/pages/home.dart';
import 'package:education_project/features/profile/presentation/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../features/bot_chat/bot_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Home(),
    BotScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        backgroundColor: Colors.white,
        items: [
          const BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.houseUser), label: 'Trang chủ'),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icon/gemini.svg',
              height: 24,
              width: 24,
            ),
            label: 'Gemini',
          ),
          const BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: 'Hồ sơ'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}