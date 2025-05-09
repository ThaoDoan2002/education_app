import 'package:education_project/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import 'otp_screen.dart';

class EmailInputPage extends StatefulWidget {
  @override
  _EmailInputPageState createState() => _EmailInputPageState();
}

class _EmailInputPageState extends State<EmailInputPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();  // Form key to validate email
  bool _isLoading = false;  // Biến trạng thái để kiểm tra nếu đang loading

  // Regular expression for email validation
  bool _isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  Future<void> sendOtp(String email) async {
    setState(() {
      _isLoading = true;  // Đặt trạng thái loading là true khi bắt đầu gửi OTP
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(
        '$BASE_URL/send-otp/',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        // Chuyển sang màn hình xác minh OTP
        context.go('/otp/$email');
      } else {
        // Xử lý lỗi nếu có
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: ${response.data}')),
        );
      }
    } catch (e) {
      print('Lỗi: $e');
    } finally {
      setState(() {
        _isLoading = false;  // Đặt trạng thái loading lại là false sau khi quá trình gửi OTP hoàn tất
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Nhập Email', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,  // Màu xanh cho AppBar
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,  // Màu nền sáng nhẹ nhàng
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo or Image (Optional)
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Image.asset(
                    'assets/my_logo/star.png',  // Thêm logo của bạn ở đây
                    height: 120,
                  ),
                ),
                // Email Input Field
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.blue),
                      hintText: 'Nhập email của bạn',
                      hintStyle: TextStyle(color: Colors.blue.shade400),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập email';
                      } else if (!_isValidEmail(value)) {
                        return 'Email không hợp lệ';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                // Send OTP Button with loading indicator
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Nếu email hợp lệ, gửi OTP
                      sendOtp(_emailController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Màu xanh cho button
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                    color: Colors.white, // Màu trắng cho progress indicator
                  )
                      : Text(
                    'Gửi Mã OTP',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
