import 'package:flutter/material.dart';

class Intro extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const Intro(
      {super.key,
      required this.image,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50), // Bán kính bo tròn
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  height: 250,
                  width: 500,
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ]),
      backgroundColor: Colors.white,
    );
  }
}
