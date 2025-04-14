class RegisterBodyParams {
  final String fName;
  final String lName;
  final String username;
  final String password;
  final String phone;
  final String token;

  RegisterBodyParams(
      {required this.token, required this.fName,
      required this.lName,
      required this.username,
      required this.password,
      required this.phone,
    });
}
