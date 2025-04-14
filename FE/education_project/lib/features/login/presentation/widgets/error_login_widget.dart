import 'package:flutter/material.dart';

class ErrorLoginWidget extends StatelessWidget {
  final String errorMessage;
  const ErrorLoginWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return   Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 15,
            color: Colors.red,
          ),
          children: [
            const WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(Icons.error, color: Colors.red),
              ),
            ),
            TextSpan(text: errorMessage),
          ],
        ),
      ),
    );
  }
}

class SuccessWidget extends StatelessWidget {
  final String message;
  const SuccessWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return   Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 15,
            color: Colors.blue,
          ),
          children: [
            const WidgetSpan(
              child: Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(Icons.info, color: Colors.blue),
              ),
            ),
            TextSpan(text: message),
          ],
        ),
      ),
    );
  }
}