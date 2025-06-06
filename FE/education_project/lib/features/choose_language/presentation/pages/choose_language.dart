import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../provider/locale_provider.dart';
import '../widgets/button_widget.dart';
import '../widgets/gesture_dectector_widget.dart';

class ChooseLanguage extends ConsumerStatefulWidget {
  const ChooseLanguage({super.key});

  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends ConsumerState<ChooseLanguage> {
  String _selectedLanguage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.only(top: 100),
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.languages_title,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 7.0,
              ),
              Text(
                AppLocalizations.of(context)!.languages_description,
                style: const TextStyle(fontSize: 16, color: Colors.black45),
              ),
              const SizedBox(
                height: 30.0,
              ),
              GestureDectectorChooseLanguage(
                onTap: () {
                  _selectedLanguage = 'Vietnamese';
                  ref
                      .read(localeNotifierProvider.notifier)
                      .setLocale(const Locale('vi'));
                },
                selectedLanguage: _selectedLanguage,
                language: 'Vietnamese',
                image: "assets/languages/vn.jpg",
                text: AppLocalizations.of(context)!.languages_vn,
              ),
              const SizedBox(
                height: 20.0,
              ),
              GestureDectectorChooseLanguage(
                onTap: () {
                  _selectedLanguage = 'English';
                  ref
                      .read(localeNotifierProvider.notifier)
                      .setLocale(const Locale('en'));
                },
                selectedLanguage: _selectedLanguage,
                language: 'English',
                image: "assets/languages/en.jpg",
                text: AppLocalizations.of(context)!.languages_en,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20.0, // Vị trí cách đáy màn hình 20.0 đơn vị
          left: 0,
          right: 0,
          child: Center(
            child: ButtonBlue(
              text: AppLocalizations.of(context)!.languages_btn,
              my_function: () {
                context.go('/boarding');
                },
            ),
          ),
        ),
      ]),
    );
  }
}
