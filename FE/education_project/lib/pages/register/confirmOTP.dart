import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class Confirmotp extends StatefulWidget {
  const Confirmotp({super.key, required this.verificationId});

  final String verificationId;

  @override
  State<Confirmotp> createState() => _ConfirmotpState();
}

class _ConfirmotpState extends State<Confirmotp> {
  final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: TextStyle(fontSize: 22, color: Colors.black),
      decoration: BoxDecoration(
          color: Colors.green.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent)));
  String validPin = '1234';
  final _formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/welcome/star.png',
          height: 73,
          width: 75,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
          margin: EdgeInsets.only(top: 40),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Vertiacation",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    "Enter the code sent to your number",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: Text(
                    '+84 937296833',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                Pinput(
                  controller: otpController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!
                          .copyWith(border: Border.all(color: Colors.green))),
                  onCompleted: (pin) {
                    print('Success: $pin');
                  },
                  errorBuilder: (errorText, pin) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          errorText ?? "",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  },
                  validator: (value) {
                    return value == validPin ? null : "Pin is incorrect";
                  },
                ),
                TextButton(
                    onPressed: () async{
                      try {
                        final cred = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: otpController.text);
                        await FirebaseAuth.instance.signInWithCredential(cred);

                        Navigator.pushNamed(context, '/home');
                      } catch (e) {
                        log(e.toString());
                      }
                    },
                    child: Text('Validate'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
