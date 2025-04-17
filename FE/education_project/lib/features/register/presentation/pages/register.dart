import 'dart:async';

import 'package:education_project/core/constants/constants.dart';
import 'package:education_project/features/register/domain/usecases/params/register_param.dart';
import 'package:education_project/features/register/presentation/provider/register_provider.dart';
import 'package:education_project/features/register/presentation/provider/state/register_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../login/presentation/widgets/button_login_widget.dart';
import '../../../login/presentation/widgets/error_login_widget.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _rePasswordFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();

  String _errorMessage = '';
  String _successMessage = '';
  String _enterFirstName = '';
  String _enterLastName = '';
  String _enterEmail = '';
  String _enterPhone = '';
  String _enterUsername = '';
  String _enterPassword = '';
  String _enterRePassword = '';

  bool _isLoad = false;
  bool _isOsecured = true;
  bool _isReOsecured = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Ẩn icon cancle khi chưa nhập số
    _passwordController.addListener(() => setState(() {}));
    _usernameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));
    _phoneController.addListener(() => setState(() {}));
    _rePasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    _rePasswordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();

    _passwordController.dispose();
    _usernameController.dispose();
    _rePasswordController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> sendToServer(String idToken) async {
      setState(() {
        _isLoad = true;
        _errorMessage = '';
        _successMessage = '';
      });

      try {
        RegisterBodyParams params = RegisterBodyParams(
          fName: _enterFirstName,
          lName: _enterLastName,
          token: idToken,
          password: _enterPassword,
          phone: _enterPhone,
          username: _enterUsername,
        );

        await ref.read(registerNotifierProvider.notifier).register(params);

        // Lấy state mới nhất của notifier
        final registerState = ref.watch(registerNotifierProvider);

        if (registerState is RegisterDone) {
          setState(() {
            _errorMessage = '';
          });
          Future.delayed(Duration(seconds: 200));
          context.go('/login');
        } else if (registerState is RegisterError) {
          setState(() {
            print(registerState.error?.response?.data['error']);
            _errorMessage = registerState.error?.response?.data['error'] ??
                'Đã có lỗi xảy ra khi gửi dữ liệu!';
          });
          // Nếu đăng ký trên server thất bại, rollback tài khoản Firebase vừa tạo
          try {
            await FirebaseAuth.instance.currentUser?.delete();
          } catch (deleteError) {
            print("Lỗi khi xoá tài khoản Firebase: $deleteError");
          }
          FocusScope.of(context).requestFocus(_firstNameFocusNode);
        }
      } catch (e) {
        setState(() {
          _errorMessage =
          'Xác minh email thành công, nhưng lỗi khi gửi dữ liệu!';
        });
        // Rollback nếu có lỗi exception
        try {
          await FirebaseAuth.instance.currentUser?.delete();
        } catch (deleteError) {
          print("Lỗi khi xoá tài khoản Firebase: $deleteError");
        }
      } finally {
        setState(() {
          _isLoad = false;
        });
      }
    }
    Future<void> registerUser() async {
      setState(() {
        _successMessage = '';
        _errorMessage = '';
        _isLoad = true;
      });

      if (!_formKey.currentState!.validate()) {
        setState(() => _isLoad = false);
        return;
      }

      if (_enterPassword != _enterRePassword) {
        // Mật khẩu không khớp
        await Future.delayed(
            const Duration(milliseconds: 1000)); // hoặc bỏ cũng được
        setState(() {
          _errorMessage = 'Mật khẩu không khớp!';
          _isLoad = false;
        });
        return; // Dừng lại không tiếp tục thực hiện API
      }

      try {
        final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await credential.user!.sendEmailVerification();

        // Check liên tục nếu user đã xác nhận email
        Timer.periodic(const Duration(seconds: 3), (timer) async {
          final user = FirebaseAuth.instance.currentUser!;
          await user.reload();

          if (user.emailVerified) {
            timer.cancel(); // Dừng kiểm tra

            final idToken = await user.getIdToken(true);
            await sendToServer(idToken!);
          }
        });

        setState(() {
          _successMessage = 'Vui lòng kiểm tra email để xác minh.';
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? 'Lỗi không xác định';
        });
      } finally {
        setState(() => _isLoad = false);
      }
    }

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
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              //  nội dung có thể cuộn
                child: Container(
                    margin: const EdgeInsets.only(top: 45, left: 20, right: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                        'Tên',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        onChanged: (fName) {
                          _enterFirstName = fName;
                        },
                        autofocus: true,
                        focusNode: _firstNameFocusNode,
                        controller: _firstNameController,
                        decoration: InputDecoration(
                          suffixIcon: _firstNameController.text.isEmpty
                              ? Container(
                            width: 0,
                          )
                              : IconButton(
                            onPressed: () {
                              _enterFirstName = '';
                              _firstNameController.clear();
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                          ),
                          filled: true,
                          fillColor:
                          _isLoad ? Colors.grey[200] : Colors.white12,
                          hintText: 'Nhập tên',
                          labelText: 'Nhập tên',
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
                              color: _isLoad ? Colors.grey : Colors.blue,
                              // Màu viền khi loading
                              width: 1.5,
                            ),
                          ),
                          hintStyle: TextStyle(
                            color: _isLoad ? Colors.grey : Colors.black,
                            // Màu chữ khi loading
                            fontSize: 17,
                          ),

                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập tên';
                          }
                        },
                        style: TextStyle(
                        fontSize: 18,
                        color: _isLoad
                            ? Colors.grey
                            : Colors.black, // Màu chữ input khi loading
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Họ',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      onChanged: (lName) {
                        _enterLastName = lName;
                      },
                      autofocus: true,
                      focusNode: _lastNameFocusNode,
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        suffixIcon: _lastNameController.text.isEmpty
                            ? Container(
                          width: 0,
                        )
                            : IconButton(
                          onPressed: () {
                            _enterLastName = '';
                            _lastNameController.clear();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        ),
                        filled: true,
                        fillColor:
                        _isLoad ? Colors.grey[200] : Colors.white12,
                        hintText: 'Nhập họ',
                        labelText: 'Nhập họ',
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
                            color: _isLoad ? Colors.grey : Colors.blue,
                            // Màu viền khi loading
                            width: 1.5,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: _isLoad ? Colors.grey : Colors.black,
                          // Màu chữ khi loading
                          fontSize: 17,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Vui lòng nhập họ';
                        }
                      },
                      style: TextStyle(
                        fontSize: 18,
                        color: _isLoad
                            ? Colors.grey
                            : Colors.black, // Màu chữ input khi loading
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Email',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (email) {
                        _enterEmail = email;
                      },
                      autofocus: true,
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        suffixIcon: _emailController.text.isEmpty
                            ? Container(
                          width: 0,
                        )
                            : IconButton(
                          onPressed: () {
                            _enterEmail = '';
                            _emailController.clear();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        ),
                        filled: true,
                        fillColor:
                        _isLoad ? Colors.grey[200] : Colors.white12,
                        hintText: 'Nhập email',
                        labelText: 'Nhập email',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _isLoad ? Colors.grey : Colors.blue,
                            // Màu viền khi loading
                            width: 1.5,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: _isLoad ? Colors.grey : Colors.black,
                          // Màu chữ khi loading
                          fontSize: 17,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        color: _isLoad
                            ? Colors.grey
                            : Colors.black, // Màu chữ input khi loading
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập email!';
                        }
                        // Regex kiểm tra định dạng email
                        final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Email không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Tên đăng nhập',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (username) {
                        print('ppppp' + _enterPhone);
                        _enterUsername = username;
                      },
                      autofocus: true,
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      decoration: InputDecoration(
                        suffixIcon: _usernameController.text.isEmpty
                            ? Container(
                          width: 0,
                        )
                            : IconButton(
                          onPressed: () {
                            _enterUsername = '';
                            _usernameController.clear();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        ),
                        filled: true,
                        fillColor:
                        _isLoad ? Colors.grey[200] : Colors.white12,
                        hintText: 'Nhập tên đăng nhập',
                        labelText: 'Nhập tên đăng nhập',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: _isLoad ? Colors.grey : Colors.blue,
                            // Màu viền khi loading
                            width: 1.5,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: _isLoad ? Colors.grey : Colors.black,
                          // Màu chữ khi loading
                          fontSize: 17,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        color: _isLoad
                            ? Colors.grey
                            : Colors.black, // Màu chữ input khi loading
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên đăng nhập!';
                        }
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text('Số điện thoại'),
                    IntlPhoneField(
                      onChanged: (phone) {
                        _enterPhone = phone.countryCode + phone.number;
                      },
                      focusNode: _phoneFocusNode,
                      controller: _phoneController,
                      decoration: InputDecoration(
                        hintText: 'Nhập số điện thoại',
                        labelText: 'Nhập số điện thoại',
                        fillColor:
                        _isLoad ? Colors.grey[200] : Colors.white12,
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
                            color: _isLoad ? Colors.grey : Colors.blue,
                            // Màu viền khi loading
                            width: 1.5,
                          ),
                        ),
                        hintStyle:
                        TextStyle(color: Colors.grey, fontSize: 17),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        color: _isLoad
                            ? Colors.grey
                            : Colors.black, // Màu chữ input khi loading
                      ),
                      keyboardType: TextInputType.phone,
                      initialCountryCode: 'VN',
                      dropdownTextStyle: TextStyle(
                        fontSize: 18.0,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // Chỉ cho phép nhập số
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      disableLengthCheck: true,
                      validator: (value) {
                        if (value!.number.isEmpty) {
                          return 'Vui lòng nhập số điện thoại!';
                        }
                        if (value!.number.length < 9 ||
                            value!.number.length > 10) {
                          return 'Số điện thoại phải từ 9 đến 10 số!';
                        }
                        final regex = RegExp(r'^(3|5|7|8|9)\d{8}$');
                        if (!regex.hasMatch(value!.number)) {
                          return 'Số điện thoại không hợp lệ!';
                        }
                        return null;
                      },
                    ),
                    Text(
                      'Mật khẩu',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      onChanged: (password) {
                        _enterPassword = password;
                      },
                      autofocus: true,
                      obscureText: _isOsecured,
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        suffixIcon: SizedBox(
                          width: _passwordController.text.isEmpty ? 10 : 105,
                          // Đặt kích thước tùy ý phù hợp với giao diện của bạn
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isOsecured = !_isOsecured;
                                  });
                                },
                                icon: _isOsecured
                                    ? const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                )
                                    : const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              if (_passwordController.text.isNotEmpty) ...[
                                Container(
                                  width: 2,
                                  height: 20,
                                  color: Colors.grey,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _enterPassword = '';
                                    _passwordController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                        filled: true,
                        fillColor:
                        _isLoad ? Colors.grey[200] : Colors.white12,
                        hintText: 'Nhập mật khâủ',
                        labelText: 'Nhập mật khẩu',
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
                            color: _isLoad ? Colors.grey : Colors.blue,
                            // Màu viền khi loading
                            width: 1.5,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: _isLoad ? Colors.grey : Colors.black,
                          // Màu chữ khi loading
                          fontSize: 17,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        color: _isLoad
                            ? Colors.grey
                            : Colors.black, // Màu chữ input khi loading
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu!';
                        }
                        if (value.length <= 5) {
                          return 'Mật khẩu phải có 6 ký tự trở lên!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Nhập lại mật khẩu',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      onChanged: (rePassword) {
                        _enterRePassword = rePassword;
                      },
                      obscureText: _isReOsecured,
                      controller: _rePasswordController,
                      focusNode: _rePasswordFocusNode,
                      decoration: InputDecoration(
                        suffixIcon: SizedBox(
                          width:
                          _rePasswordController.text.isEmpty ? 10 : 105,
                          // Đặt kích thước tùy ý phù hợp với giao diện của bạn
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isReOsecured = !_isReOsecured;
                                  });
                                },
                                icon: _isReOsecured
                                    ? const Icon(
                                  Icons.visibility,
                                  color: Colors.grey,
                                )
                                    : const Icon(
                                  Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              if (_rePasswordController.text.isNotEmpty) ...[
                                Container(
                                  width: 2,
                                  height: 20,
                                  color: Colors.grey,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _enterRePassword = '';
                                    _rePasswordController.clear();
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                        filled: true,
                        fillColor:
                        _isLoad ? Colors.grey[200] : Colors.white12,
                        hintText: 'Nhập lại mật khẩu',
                        labelText: 'Nhập lại mật khẩu',
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
                            color: _isLoad ? Colors.grey : Colors.blue,
                            // Màu viền khi loading
                            width: 1.5,
                          ),
                        ),
                        hintStyle: TextStyle(
                          color: _isLoad ? Colors.grey : Colors.black,
                          // Màu chữ khi loading
                          fontSize: 17,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      style: TextStyle(
                        fontSize: 18,
                        color: _isLoad
                            ? Colors.grey
                            : Colors.black, // Màu chữ input khi loading
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập lại mật khẩu';
                        }

                        return null;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (_errorMessage != '' && _isLoad == false)
                ErrorLoginWidget(errorMessage: _errorMessage!),
            const SizedBox(
              height: 12,
            ),
            if (_successMessage != '' && _isLoad == false)
        SuccessWidget(message: _successMessage!),
    const SizedBox(
    height: 12,
    ),
    ButtonBlue2(
    isLoad: _isLoad,
    function: () {
    registerUser(); // Gọi hàm ở đây
    },
    text: 'Register',
    ),
    SizedBox(
    height: 20,
    ),
    ]),
    ),
    ),
    )),
    );
    }
}
