import 'package:flutter/material.dart';

class BoxColor extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final Offset offset1;
  final Offset offset2;
  final double blur;
  final double spread;
  final Color color1;
  final Color color2;
  const BoxColor({super.key, required this.height, required this.width, required this.radius,  required this.blur, required this.spread, required this.offset1, required this.offset2, required this.color1, required this.color2});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color1,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
                color: color2,
                offset: offset1,
                blurRadius: blur,
                spreadRadius: spread),
            BoxShadow(
                color: color2,
                offset: offset2,
                blurRadius: blur,
                spreadRadius: spread)
          ]),
    );
  }
}
