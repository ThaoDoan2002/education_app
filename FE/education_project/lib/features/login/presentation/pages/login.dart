import 'package:education_project/features/login/presentation/provider/state/login_state.dart';
import 'package:education_project/features/login/presentation/widgets/password_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/usecases/params/login_param.dart';
import '../provider/login_provider.dart';
import '../widgets/button_login_widget.dart';
import '../widgets/error_login_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String errorMessage = '';
  String enteredPassword = '';
  String enteredUsername = '';
  bool isLoad = false;
  bool isOsecured = true;

  @override
  void initState() {
    super.initState();

    // Ẩn icon cancle khi chưa nhập số
    _passwordController.addListener(() => setState(() {}));
    _usernameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> handleLogin() async {
      if (enteredUsername.isEmpty) {
        setState(() {
          errorMessage = 'Vui lòng nhập Username';
        });
        return;
      } else if (enteredPassword.isEmpty) {
        setState(() {
          errorMessage = 'Vui lòng nhập mật khẩu';
        });
        return;
      }
      if (isLoad == false) {
        // Ẩn bàn phím sau khi nhấn nút
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          isLoad = true;
        });
      }

      // Tạo đối tượng params cho login
      LoginBodyParams params = LoginBodyParams(
        username: enteredUsername,
        password: enteredPassword,
      );
      // Gọi phương thức login

      await ref.read(loginNotifierProvider.notifier).login(params);
      final loginState = ref.read(loginNotifierProvider);
      if (loginState is LoginDone) {
        errorMessage = '';
        context.go('/home');
      } else if (loginState is LoginError) {
        setState(() {
          errorMessage = 'Username or Password invalid!';
          enteredPassword = '';
          enteredUsername = '';
          _usernameController.clear();
          _passwordController.clear();
        });
        FocusScope.of(context).requestFocus(_usernameFocusNode);
      }
      setState(() {
        isLoad = false;
      });
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
      body: SingleChildScrollView(
        //  nội dung có thể cuộn
        child: Container(
          margin: const EdgeInsets.only(top: 45, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                AppLocalizations.of(context)!.login_username,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                onChanged: (username) {
                  enteredUsername = username;
                },
                autofocus: true,
                focusNode: _usernameFocusNode,
                controller: _usernameController,
                decoration: InputDecoration(
                  suffixIcon: _usernameController.text.isEmpty
                      ? Container(
                          width: 0,
                        )
                      : IconButton(
                          onPressed: () {
                            enteredUsername = '';
                            _usernameController.clear();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        ),
                  filled: true,
                  fillColor: isLoad ? Colors.grey[200] : Colors.white12,
                  hintText: AppLocalizations.of(context)!.login_hint_username,
                  labelText: AppLocalizations.of(context)!.login_hint_username,
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
                      color: isLoad ? Colors.grey : Colors.blue,
                      // Màu viền khi loading
                      width: 1.5,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: isLoad ? Colors.grey : Colors.black,
                    // Màu chữ khi loading
                    fontSize: 17,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: isLoad
                      ? Colors.grey
                      : Colors.black, // Màu chữ input khi loading
                ),
              ),
              SizedBox(
                height: 12,
              ),
              TextPass(),
              const SizedBox(
                height: 8,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.login_invalid_password;
                  }
                  return null;
                },
                onChanged: (password) {
                  enteredPassword = password;
                },
                obscureText: isOsecured,
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                decoration: InputDecoration(
                  suffixIcon: SizedBox(
                    width: _passwordController.text.isEmpty ? 10 : 105,
                    // Đặt kích thước tùy ý phù hợp với giao diện của bạn
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isOsecured = !isOsecured;
                            });
                          },
                          icon: isOsecured
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
                              enteredPassword = '';
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
                  fillColor: isLoad ? Colors.grey[200] : Colors.white12,
                  hintText: AppLocalizations.of(context)!.login_hint_password,
                  labelText: AppLocalizations.of(context)!.login_hint_password,
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
                      color: isLoad ? Colors.grey : Colors.blue,
                      // Màu viền khi loading
                      width: 1.5,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: isLoad ? Colors.grey : Colors.black,
                    // Màu chữ khi loading
                    fontSize: 17,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: isLoad
                      ? Colors.grey
                      : Colors.black, // Màu chữ input khi loading
                ),
              ),
              SizedBox(
                height: 12,
              ),
              if (errorMessage != '' && isLoad == false)
                ErrorLoginWidget(errorMessage: errorMessage!),
              const SizedBox(
                height: 12,
              ),
              ButtonBlue2(
                  isLoad: isLoad,
                  function: handleLogin,
                  text: AppLocalizations.of(context)!.login_signin_btn),
              SizedBox(
                height: 20,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
