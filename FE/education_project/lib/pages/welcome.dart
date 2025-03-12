import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/buttons/button_widget.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF004A99),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0, -70),
                    child: Stack(alignment: Alignment.center, children: [
                      Container(
                        height: 430,
                        width: 500,
                        decoration: BoxDecoration(
                            color: Color(0xFF004A99),
                            borderRadius: BorderRadius.circular(170),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 5,
                                  spreadRadius: 1.0),
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 5,
                                  spreadRadius: 1.0)
                            ]),
                      ),
                      Container(
                        height: 350,
                        width: 390,
                        decoration: BoxDecoration(
                            color: Color(0xFF004A99),
                            borderRadius: BorderRadius.circular(190),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 5,
                                  spreadRadius: 1.0),
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 5,
                                  spreadRadius: 1.0)
                            ]),
                      ),
                      Container(
                        height: 210,
                        width: 280,
                        decoration: BoxDecoration(
                            color: Color(0xFF004A99),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 10,
                                  spreadRadius: 2.0),
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 10,
                                  spreadRadius: 2.0)
                            ]),
                      ),
                      Container(
                        height: 140,
                        width: 230,
                        decoration: BoxDecoration(
                            color: Color(0xFF004A99),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 10,
                                  spreadRadius: 2.0),
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 10,
                                  spreadRadius: 2.0)
                            ]),
                      ),
                      Container(
                        height: 100,
                        width: 180,
                        decoration: BoxDecoration(
                            color: Color(0xFF004A99),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 10,
                                  spreadRadius: 2.0),
                              BoxShadow(
                                  color: Colors.white10,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 10,
                                  spreadRadius: 2.0)
                            ]),
                      ),
                      Container(
                        height: 60,
                        width: 130,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(150),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white60,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 10,
                                  spreadRadius: 2.0),
                              BoxShadow(
                                  color: Colors.white60,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 10,
                                  spreadRadius: 2.0)
                            ]),
                      ),
                      Container(
                        width: 100,
                        height: 150,
                        child: Image.asset('assets/welcome/star.png'),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 200),
                        child: Text('LOGO',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      )
                    ]),
                  ),
                  SizeTransition(
                    sizeFactor: _animation,
                    axis: Axis.vertical,
                    axisAlignment: 1,
                    child: Container(
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
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                              // Thiết lập style tùy chỉnh
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .welcome_span2,

                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                      fontSize: 16), // Style riêng
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .welcome_span3,

                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize:
                                          17), // Ghi đè màu sắc và kích thước
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .welcome_span4,

                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          16), // Ghi đè màu sắc và kích thước
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .welcome_span5,

                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize:
                                          17), // Style riêng cho đoạn cuối
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
