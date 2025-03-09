import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Tự động focus khi trang vừa được mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose(); // Giải phóng FocusNode khi không còn sử dụng
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset(
          'assets/logo/logo.png',
          height: 200,
          width: 50,
        ),
      ),
      body: SingleChildScrollView(
        // Đảm bảo nội dung có thể cuộn
        child: Container(
          margin: EdgeInsets.only(top: 45, left: 30, right: 30),
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
                focusNode: _phoneFocusNode,
                decoration: InputDecoration(
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
                      color: Colors.blue, // Màu viền xanh khi focus
                      width: 1.5,
                      // Độ rộng viền khi focus
                    ),
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                style: TextStyle(fontSize: 18),
                keyboardType: TextInputType.phone,
                initialCountryCode: 'VN',
                dropdownTextStyle: TextStyle(
                  fontSize: 18.0,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // Chỉ cho phép nhập số
                ],
              ),
              // Thêm các widget khác nếu cần
            ],
          ),
        ),
      ),
    );
  }
}
