import 'dart:developer';

import 'package:education_project/pages/register/confirmOTP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _phoneFocusNode = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;
  bool isPassed = false;
  String? errorMessage;
  String enteredPhoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
            //  nội dung có thể cuộn
            child: Container(
          margin: EdgeInsets.only(top: 45, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Số điện thoại',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                IntlPhoneField(
                  controller: _phoneController,
                  onChanged: (phone) {
                    setState(() {

                      enteredPhoneNumber = phone.number;

                    });
                  },
                  focusNode: _phoneFocusNode,
                  decoration: InputDecoration(
                    suffixIcon:
                        _phoneController.text.isEmpty || isLoading || isPassed
                            ? Container(
                                width: 0,
                              )
                            : IconButton(
                                onPressed: () {
                                  enteredPhoneNumber = '';
                                  _phoneController.clear();
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                )),
                    filled: true,
                    fillColor: isLoading || isPassed
                        ? Colors.grey[200]
                        : Colors.white12,
                    hintText: 'Nhập số điện thoại',
                    labelText: 'Nhập số điện thoại',
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isLoading ? Colors.grey : Colors.blue,
                        // Màu viền khi loading
                        width: 1.5,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: isLoading ? Colors.grey : Colors.black,
                      // Màu chữ khi loading
                      fontSize: 17,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    color: isLoading
                        ? Colors.grey
                        : Colors.black, // Màu chữ input khi loading
                  ),
                  keyboardType: TextInputType.phone,
                  initialCountryCode: 'VN',
                  invalidNumberMessage: "Số điện thoại không hợp lệ!",
                  disableLengthCheck: true,
                  validator: (phone) async {
                    if (!RegExp(r'^[3|5|7|8|9][1-9]{9}$')
                        .hasMatch(phone!.number)) {
                      return 'Số điện thoại không hợp lệ. Số phải có độ dài 9 chữ số';
                    }
                    return null;
                  },
                  dropdownTextStyle: TextStyle(
                    fontSize: 18.0,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly, //chỉ nhận số
                  ],
                ),

                if (errorMessage != null && !isLoading)
                  Container(
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
                  ),

                const SizedBox(
                  height: 12,
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(380, 50),
                    backgroundColor: isLoading
                        ? Colors.grey // Nút chuyển thành màu xám khi loading
                        : Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (enteredPhoneNumber.isEmpty) {
                      setState(() {
                        errorMessage = 'Vui lòng nhập số điện thoại';
                      });
                      return;
                    }
                    enteredPhoneNumber = '+84$enteredPhoneNumber';
                    print(enteredPhoneNumber);

                    if (!isLoading) {
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());

                        isLoading = true;
                      });
                      FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: enteredPhoneNumber,
                          verificationCompleted: (phoneAuthCredential) {},
                          verificationFailed: (error) {
                            log(error.toString());
                          },
                          codeSent: (verificationID, forceResendingToken) {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Confirmotp(verificationId: verificationID,)));
                          },
                          codeAutoRetrievalTimeout: (verificationID) {
                            log("Auto Retrieval timeout");
                          });
                    }
                  },
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Đăng ký',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        )
                      : Text(
                          'Đăng ký ',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                // Thêm các widget khác nếu cần
              ],
            ),
          ),
        )));
  }
}
