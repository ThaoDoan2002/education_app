import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/features/login/presentation/provider/state/login_state.dart';
import 'package:education_project/features/welcome/presentation/widgets/box_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../../../config/storage/token_storage.dart';
import '../../../../core/constants/constants.dart';
import '../../../choose_language/presentation/widgets/button_widget.dart';
import '../../../home/presentation/provider/get_user_provider.dart';
import '../../../login/domain/usecases/params/login_param.dart';
import '../../../login/presentation/provider/login_provider.dart';

class Welcome extends ConsumerStatefulWidget {
  const Welcome({super.key});

  @override
  ConsumerState<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends ConsumerState<Welcome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final googleProvider = GoogleAuthProvider();

  User? _user;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut);
    _controller.forward();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Future<void> _registerDeviceToken() async {
      try {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        String? token = await messaging.getToken();
        final tokenOauth = await TokenStorage().getAccessToken();
        final Dio dio = Dio();
        if (token != null) {
          await dio.post(
            '$BASE_URL/save-device-token/',
            data: {
              'token': token,
              'platform': Platform.isAndroid ? 'android' : 'ios',
            },
            options: Options(headers: {
              'Authorization': 'Bearer $tokenOauth', // nếu cần token auth
            }),
          );
        }
      } catch (e) {
        print('Lỗi khi gửi device token: $e');
      }
    }
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFF004A99),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Transform.translate(
              offset: Offset(0, -70),
              child: Stack(alignment: Alignment.center, children: [
                BoxColor(
                  color1: Color(0xFF004A99),
                  color2: Colors.white10,
                  height: 430,
                  width: 500,
                  radius: 170,
                  offset1: Offset(4.0, 4.0),
                  blur: 5,
                  spread: 1.0,
                  offset2: Offset(-4.0, -4.0),
                ),
                BoxColor(
                  color1: Color(0xFF004A99),
                  color2: Colors.white10,
                  height: 350,
                  width: 390,
                  radius: 190,
                  offset1: Offset(4.0, 4.0),
                  blur: 5,
                  spread: 1.0,
                  offset2: Offset(-4.0, -4.0),
                ),
                BoxColor(
                  color1: Color(0xFF004A99),
                  color2: Colors.white10,
                  height: 210,
                  width: 280,
                  radius: 100,
                  offset1: Offset(4.0, 4.0),
                  blur: 10,
                  spread: 2.0,
                  offset2: Offset(-4.0, -4.0),
                ),
                BoxColor(
                  color1: Color(0xFF004A99),
                  color2: Colors.white10,
                  height: 140,
                  width: 230,
                  radius: 100,
                  offset1: Offset(4.0, 4.0),
                  blur: 10,
                  spread: 2.0,
                  offset2: Offset(-4.0, -4.0),
                ),
                BoxColor(
                  color1: Colors.white,
                  color2: Colors.white60,
                  height: 60,
                  width: 130,
                  radius: 150,
                  offset1: Offset(4.0, 4.0),
                  blur: 10,
                  spread: 2.0,
                  offset2: Offset(-4.0, -4.0),
                ),
                Container(
                  width: 100,
                  height: 150,
                  child: Image.asset('assets/welcome/star.png'),
                ),
              ]),
            ),
            SizeTransition(
              sizeFactor: _animation,
              axis: Axis.vertical,
              axisAlignment: 1,
              child: Container(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                margin: EdgeInsets.only(top: size.height * 0.35),
                height: 560,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24))),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.welcome_title,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ButtonBlue(
                      text: AppLocalizations.of(context)!.welcome_login,
                      my_function: () {
                        context.push('/login');
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(380, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(
                            color: Colors.blueAccent,
                          ),
                        ),
                        onPressed: () {
                          context.push('/email');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.welcome_register,
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 19,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 12,
                    ),
                    SignInButton(Buttons.google,
                        text: AppLocalizations.of(context)!.welcome_google,
                        // Đặt màu nền cho nút
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Đặt borderRadius theo ý muốn
                        ),
                        elevation: 1, onPressed: () async {
                          try {
                            final userCredential = await _auth.signInWithProvider(googleProvider);
                            final idToken = await userCredential.user?.getIdToken();

                            if (idToken != null) {
                              final params = SocialLoginBodyParams(idToken: idToken);

                              await ref.read(socialLoginNotifierProvider.notifier).socialLogin(params);
                              final state = ref.read(socialLoginNotifierProvider);
                              print(state);
                              if(state is LoginDone){
                                final newToken = await TokenStorage().getAccessToken();
                                ref.read(tokenProvider.notifier).state = newToken;
                                await _registerDeviceToken();
                                context.go('/home');
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Không thể đăng nhập. Vui lòng thử lại.')),
                                );
                              }
                            }
                          } catch (e) {
                            print("Error during Google sign-in: $e");
                          }
                        }),
                    const SizedBox(
                      height: 35,
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.welcome_span1,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                        // Thiết lập style tùy chỉnh
                        children: [
                          WidgetSpan(
                              child: GestureDetector(
                            onTap: () {
                              print('DOING');
                            },
                            child: Text(
                              AppLocalizations.of(context)!.welcome_span2,

                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 16), // Style riêng
                            ),
                          )),
                          TextSpan(
                            text: AppLocalizations.of(context)!.welcome_span3,

                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17), // Ghi đè màu sắc và kích thước
                          ),
                          WidgetSpan(
                              child: GestureDetector(
                            onTap: () {
                              print('DOING');
                            },
                            child: Text(
                              AppLocalizations.of(context)!.welcome_span4,

                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16), // Ghi đè màu sắc và kích thước
                            ),
                          )),
                          TextSpan(
                            text: AppLocalizations.of(context)!.welcome_span5,

                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 17), // Style riêng cho đoạn cuối
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
