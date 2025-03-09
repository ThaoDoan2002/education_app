import 'package:education_project/pages/intro/intro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widgets/gesture_detectors/gesture_dectector_widget.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            isLastPage = (index == 2);
          });
        },
        children: [
          Intro(
            image: 'assets/intro/intro1.jpg',
            title: AppLocalizations.of(context)!.intro1_title,
            description: AppLocalizations.of(context)!.intro1_description,
          ),
          Intro(
            image: 'assets/intro/intro2.jpg',
            title: AppLocalizations.of(context)!.intro2_title,
            description: AppLocalizations.of(context)!.intro2_description,
          ),
          Intro(
            image: 'assets/intro/intro3.jpg',
            title: AppLocalizations.of(context)!.intro3_title,
            description: AppLocalizations.of(context)!.intro3_description,
          ),
        ],
      ),
      Container(
          alignment: const Alignment(0, 0.85),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDectectorOnBoarding(
                text: AppLocalizations.of(context)!.onboarding_skip,
                onTap: () {
                  _controller.jumpToPage(2);
                },
              ),
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const ExpandingDotsEffect(),
              ),
              isLastPage
                  ? GestureDectectorOnBoarding(
                      text: AppLocalizations.of(context)!.onboarding_start,
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('isOnboardingCompleted', true);
                        Navigator.pushReplacementNamed(context, '/welcome');
                      })
                  : GestureDectectorOnBoarding(
                      text: AppLocalizations.of(context)!.onboarding_continue,
                      onTap: () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                    )
            ],
          ))
    ]);
  }
}
