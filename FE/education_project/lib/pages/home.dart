import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/buttons/button_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: Color(0xFF004A99),
      body: Transform.translate(
        offset: Offset(-100,0),
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
            child: Text('BEST STUDY',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          )
        ]),
      ),
    );
  }
}
