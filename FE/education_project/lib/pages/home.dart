import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../features/choose_language/presentation/widgets/button_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google SignIn"),
      ),
      body: _user != null ? _userInfo() : _googleSignInButon(),
    );
  }

  Widget _googleSignInButon() {
    return Center(
      child: SizedBox(
        height: 50,
        child: SignInButton(Buttons.google,
            text: "Sign up with google", onPressed: _handleGoogleSignIn),
      ),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(_user!.photoURL!))),
          ),
          Text(_user!.email!),
          MaterialButton(
            onPressed: _auth.signOut,
            color: Colors.red,
            child: Text("Sign out"),
          )
        ],
      ),
    );
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider);
    } catch (error) {
      print(error);
    }
  }
}
