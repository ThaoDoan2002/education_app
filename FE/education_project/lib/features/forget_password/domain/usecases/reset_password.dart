import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';
import 'package:education_project/features/forget_password/domain/usecases/params/reset_password_param.dart';

import '../../../login/domain/repository/auth_repository.dart';

class ResetPasswordUseCase implements UseCase<void,ResetPasswordBodyParams>{
  final ForgotPasswordRepository _forgotPasswordRepository;

  ResetPasswordUseCase(this._forgotPasswordRepository);

  @override
  Future<void> call({ResetPasswordBodyParams? params}) async {
    try {
      await _forgotPasswordRepository.resetPassword(params!);

    } catch (e) {
      rethrow;
    }
  }


}