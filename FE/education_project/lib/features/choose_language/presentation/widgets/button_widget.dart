import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  final String text;
  final VoidCallback my_function;
  const ButtonBlue({super.key, required this.text, required this.my_function});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(380, 50),
          backgroundColor: Colors.blue[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: my_function,
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ));
  }
}


