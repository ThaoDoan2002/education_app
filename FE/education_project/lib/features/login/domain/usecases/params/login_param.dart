class LoginBodyParams {
  final String username;
  final String password;

  LoginBodyParams({required this.username, required this.password});
}

class SocialLoginBodyParams{
  final String idToken;
  SocialLoginBodyParams({required this.idToken});
}