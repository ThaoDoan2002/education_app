import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class GestureDetectureLogin extends StatelessWidget {
  final VoidCallback function;
  final Icon icon;
  final String text;

  const GestureDetectureLogin(
      {super.key,
      required this.function,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: function,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(text: AppLocalizations.of(context)!.login_method_text),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        icon,
                        Text(
                          text,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
