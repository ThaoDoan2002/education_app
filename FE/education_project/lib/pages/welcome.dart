import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/buttons/button_widget.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/welcome/welcome.jpg',
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                    margin: EdgeInsets.only(top: size.height * 0.35),
                    height: 500,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.welcome_title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ButtonBlue(
                          text: AppLocalizations.of(context)!.welcome_login,
                          my_function: () {
                            Navigator.pushNamed(context, '/login');
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(380, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                color: Colors.blueAccent,
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              AppLocalizations.of(context)!.welcome_register,
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontSize: 19,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: AppLocalizations.of(context)!.welcome_span1,
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                            // Thiết lập style tùy chỉnh
                            children: <TextSpan>[
                              TextSpan(
                                text: AppLocalizations.of(context)!.welcome_span2,
        
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 16), // Style riêng
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!.welcome_span3,
        
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 17), // Ghi đè màu sắc và kích thước
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!.welcome_span4,
        
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16), // Ghi đè màu sắc và kích thước
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!.welcome_span5,
        
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 17), // Style riêng cho đoạn cuối
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
