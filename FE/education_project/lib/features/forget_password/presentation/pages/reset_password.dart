import 'package:dio/dio.dart';
import 'package:education_project/features/forget_password/domain/usecases/params/reset_password_param.dart';
import 'package:education_project/features/forget_password/presentation/provider/forget_password_provider.dart';
import 'package:education_project/features/login/presentation/widgets/password_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../login/presentation/widgets/button_login_widget.dart';
import '../../../login/presentation/widgets/error_login_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../provider/state/reset_password_state.dart';


class ResetPasswordPage extends ConsumerStatefulWidget {
  final String uid;
  final String token;

  const ResetPasswordPage({required this.uid, required this.token, Key? key})
      : super(key: key);

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {


  final _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _rePasswordFocusNode = FocusNode();
  final TextEditingController _rePasswordController = TextEditingController();
  String _enterPassword = '';
  String _reEnterPassword = '';
  String _errorMessage = "";
  bool _isLoad = false;
  bool _isOsecured = true;
  bool _isReOsecured = true;


  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _rePasswordController.addListener(() => setState(() {}));

  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    _rePasswordFocusNode.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Future<void> resetPassword(BuildContext context) async {
      setState(() {
        _isLoad = true;
        _errorMessage = '';
      });

      if (!_formKey.currentState!.validate()) {
        setState(() => _isLoad = false);
        return;
      }

      if (_enterPassword != _reEnterPassword) {
        // Mật khẩu không khớp
        await Future.delayed(
            const Duration(milliseconds: 200)); // hoặc bỏ cũng được
        setState(() {
          _errorMessage = 'Mật khẩu không khớp!';
          _isLoad = false;
        });
        return; // Dừng lại không tiếp tục thực hiện API
      }

      try {
        ResetPasswordBodyParams params = ResetPasswordBodyParams(
          uid: widget.uid,
          token: widget.token,
          password: _enterPassword
        );
        await ref
            .read(resetPasswordNotifierProvider.notifier)
            .resetPassword(params);
        final resetPassState = ref.watch(resetPasswordNotifierProvider);
        // Nếu thành công
        if (resetPassState is ResetPasswordDone) {
          setState(() {
            _errorMessage = '';
          });

          await Future.delayed(
              const Duration(seconds: 200)); // optional, để UX mượt hơn
          context.go('/login');

        } else if (resetPassState is ResetPasswordError) {
          setState(() {
            _errorMessage = resetPassState.error!.response?.data['message'];

            _enterPassword = '';
            _reEnterPassword = '';
            _passwordController.clear();
            _rePasswordController.clear();


          });
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        }


      } on DioException catch (e) {
        setState(() {
          _errorMessage = e.response?.data['message'] ?? 'Có lỗi xảy ra';
        });
      } finally {
        setState(() {
          _isLoad = false;
        });
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
        body: Container(
          margin: const EdgeInsets.only(top: 45, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.reset_pass_title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.reset_pass_desc,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Password',
                  style: TextStyle(fontSize: 16),
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
                    fillColor: _isLoad ? Colors.grey[200] : Colors.white12,
                    hintText: AppLocalizations.of(context)!.reset_pass_input_pass,
                    labelText:
                    AppLocalizations.of(context)!.reset_pass_input_pass,
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
                      return AppLocalizations.of(context)!.reset_pass_error_empty;
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Email',
                  style: TextStyle(fontSize: 16),
                ),
                TextFormField(
                  onChanged: (rePassword) {
                    _reEnterPassword = rePassword;
                  },
                  obscureText: _isReOsecured,
                  controller: _rePasswordController,
                  focusNode: _rePasswordFocusNode,
                  decoration: InputDecoration(
                    suffixIcon: SizedBox(
                      width: _rePasswordController.text.isEmpty ? 10 : 105,
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
                                _reEnterPassword = '';
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
                    fillColor: _isLoad ? Colors.grey[200] : Colors.white12,
                    hintText: AppLocalizations.of(context)!.reset_pass_input_repass,
                    labelText:
                    AppLocalizations.of(context)!.reset_pass_input_repass,
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
                      return AppLocalizations.of(context)!.reset_pass_error_re_empty;
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (_errorMessage != '' && _isLoad == false)
                  ErrorLoginWidget(errorMessage: _errorMessage!),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonBlue2(
                        isLoad: _isLoad,
                        function: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          // Ẩn bàn phím
                          FocusScope.of(context).unfocus();
                          resetPassword(context);
                        },
                        text: AppLocalizations.of(context)!.reset_pass_btn_submit)
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
