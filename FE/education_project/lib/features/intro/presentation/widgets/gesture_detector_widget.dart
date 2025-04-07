import 'package:flutter/material.dart';

class GestureDectectorOnBoarding extends StatelessWidget {
  final Function onTap;
  final String text;

  const GestureDectectorOnBoarding(
      {super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Text(
        text,
        style: const TextStyle(
          decoration: TextDecoration.none,
          fontSize: 16,
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
