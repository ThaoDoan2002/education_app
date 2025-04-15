import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/forget_password/presentation/pages/reset_password.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? isOnboardingCompleted = prefs.getBool('isOnboardingCompleted');

    if (isOnboardingCompleted == null) {
      context.go('/languages');
    } else {
      context.go('/welcome');

    }
  }

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:  Center(
            child: Lottie.asset("assets/animations/person.json")));
  }
}
