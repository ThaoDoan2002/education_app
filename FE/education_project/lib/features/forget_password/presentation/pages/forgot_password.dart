import 'package:dio/dio.dart';
import 'package:education_project/features/forget_password/presentation/pages/reset_password.dart';
import 'package:education_project/features/forget_password/presentation/provider/forget_password_provider.dart';
import 'package:education_project/features/forget_password/presentation/provider/state/forget_password_state.dart';
import 'package:education_project/features/login/presentation/widgets/button_login_widget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';


import '../../../login/presentation/widgets/error_login_widget.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  String _enteredEmail = '';
  String _errorMsg = '';
  bool _isLoad = false;
  bool _isSubmit = false;

  Future<bool> handleDynamicLinks(BuildContext context) async {
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (await _handleLinkData(initialLink, context)) {
      return true;
    }

    FirebaseDynamicLinks.instance.onLink.listen(
      (dynamicLinkData) {
        _handleLinkData(dynamicLinkData, context);
      },
      onError: (error) => print('Lỗi dynamic link: $error'),
    );

    return false;
  }

  Future<bool> _handleLinkData(
      PendingDynamicLinkData? data, BuildContext context) async {
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      final uid = deepLink.queryParameters['uid'];
      final token = deepLink.queryParameters['token'];
      if (uid != null && token != null && context.mounted) {
        context.go('/reset-password?uid=$uid&token=$token');

        return true;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    handleDynamicLinks(context);
    // Ẩn icon cancle khi chưa nhập
    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> sendResetEmail() async {
      setState(() => _isLoad = true);
      try {
        await ref
            .read(forgetPasswordNotifierProvider.notifier)
            .sendEmail(_enteredEmail);
        final forgetPassState = ref.watch(forgetPasswordNotifierProvider);

        if (forgetPassState is ForgetPasswordDone) {
          _errorMsg = '';
        } else if (forgetPassState is ForgetPasswordError) {
          setState(() {
            _errorMsg = forgetPassState.error!.response?.data['message'];

            _enteredEmail = '';
            _emailController.clear();
          });
          FocusScope.of(context).requestFocus(_emailFocusNode);
        }
      } on DioException catch (e) {
        _errorMsg = e.response?.data['message'];
      } finally {
        setState(() {
          _isLoad = false;
          _isSubmit = true;
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
                  AppLocalizations.of(context)!.forgot_pass_title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.forgot_pass_desc,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: (email) {
                    _enteredEmail = email;
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
                              _enteredEmail = '';
                              _emailController.clear();
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ),
                          ),
                    filled: true,
                    fillColor: _isLoad ? Colors.grey[200] : Colors.white12,
                    hintText: AppLocalizations.of(context)!.forgot_pass_input_email,
                    labelText: AppLocalizations.of(context)!.forgot_pass_input_email,
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
                      return AppLocalizations.of(context)!.forgot_pass_error_empty;
                    }
                    // Regex kiểm tra định dạng email
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) {
                      return AppLocalizations.of(context)!.forgot_pass_error_invalid;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                if (_errorMsg != '' && _isLoad == false)
                  ErrorLoginWidget(errorMessage: _errorMsg!),
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
                          sendResetEmail();
                        },
                        text: _isSubmit == false ? AppLocalizations.of(context)!.forgot_pass_btn_submit : AppLocalizations.of(context)!.forgot_pass_btn_resend)
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
