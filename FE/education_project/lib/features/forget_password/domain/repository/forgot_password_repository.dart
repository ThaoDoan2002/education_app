
import 'package:education_project/features/forget_password/domain/usecases/params/reset_password_param.dart';

abstract class ForgotPasswordRepository {
  Future<void> sendEmail(String email);
  Future<void> resetPassword(ResetPasswordBodyParams params);
}