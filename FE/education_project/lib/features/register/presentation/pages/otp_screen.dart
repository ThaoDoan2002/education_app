import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/constants.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  OtpVerificationPage({required this.email});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;  // Biến để kiểm tra trạng thái loading

  Future<void> verifyOtp(String email, String otp) async {
    setState(() {
      _isLoading = true;  // Bắt đầu loading khi verify OTP
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(
        '$BASE_URL/verify-otp/',
        data: {'email': email, 'otp': otp},
      );

      if (response.statusCode == 200) {
        // Chuyển sang màn hình nhập thông tin người dùng
        context.go('/register-info/${widget.email}');
      } else {
        // Xử lý lỗi nếu OTP không hợp lệ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mã OTP không hợp lệ')),
        );
      }
    } catch (e) {
      print('Lỗi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã có lỗi xảy ra, vui lòng thử lại!')),
      );
    } finally {
      setState(() {
        _isLoading = false;  // Kết thúc trạng thái loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Nhập Mã OTP', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue,  // Màu của AppBar
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Đoạn văn bản hướng dẫn
            Text(
              'Vui lòng nhập mã OTP đã được gửi đến email ${widget.email}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            // Trường nhập OTP
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Mã OTP',
                labelStyle: TextStyle(color: Colors.blue),
                hintText: 'Nhập mã OTP',
                hintStyle: TextStyle(color: Colors.blue.shade400),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
            SizedBox(height: 20),
            // Nút xác minh OTP
            ElevatedButton(
              onPressed: _isLoading
                  ? null  // Nếu đang loading, disable nút
                  : () {
                if (_otpController.text.isNotEmpty) {
                  verifyOtp(widget.email, _otpController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng nhập mã OTP')),
                  );
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
                color: Colors.white, // Màu trắng cho loading spinner
              )
                  : Text(
                'Xác Minh OTP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
