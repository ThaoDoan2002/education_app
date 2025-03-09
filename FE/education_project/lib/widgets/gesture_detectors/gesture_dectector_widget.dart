import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

class GestureDectectorChooseLanguage extends StatelessWidget {
  final VoidCallback onTap;
  final String selectedLanguage;
  final String language;
  final String image;
  final String text;

  const GestureDectectorChooseLanguage(
      {super.key,
      required this.onTap,
      required this.selectedLanguage,
      required this.language,
      required this.image,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selectedLanguage == language
              ? Colors.blue.shade100 // Màu khi được chọn
              : Colors.transparent, // Màu khi chưa được chọn
          border: Border.all(
            color: selectedLanguage == language
                ? Colors.blue // Viền khi được chọn
                : Colors.grey.shade200, // Viền khi chưa được chọn
            width: 1.0, // Độ dày của đường viền
          ),
          borderRadius: BorderRadius.circular(15), // Bo tròn góc viền
        ),
        padding: const EdgeInsets.all(15),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: AssetImage(image),
            radius: 15,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            text,
          )
        ]),
      ),
    );
  }
}
