import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final bool isLoad;
  final VoidCallback function;
  final String text;
  const ButtonLogin({super.key, required this.isLoad, required this.function, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(380, 50),
        backgroundColor: isLoad
            ? Colors
            .grey // Nút chuyển thành màu xám khi loading
            : Colors.blue[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: function,
      child: isLoad
          ? Row(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18),
          )
        ],
      )
          : Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 18),
      ),
    );
  }
}