import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      Navigator.pushReplacementNamed(context, '/languages');
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), checkStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:  Center(
            child: Lottie.asset("assets/animations/person.json")));
  }
}
