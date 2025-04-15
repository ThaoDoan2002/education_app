import 'package:education_project/features/login/domain/usecases/params/login_param.dart';

abstract class AuthRepository {
  Future<void> login(LoginBodyParams params);
}