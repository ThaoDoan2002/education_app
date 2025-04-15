import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';

import '../../../login/domain/repository/auth_repository.dart';

class ForgetPasswordUseCase implements UseCase<void,String>{
  final ForgotPasswordRepository _forgotPasswordRepository;

  ForgetPasswordUseCase(this._forgotPasswordRepository);

  @override
  Future<void> call({String? params}) async {
    try {
      await _forgotPasswordRepository.sendEmail(params!);

    } catch (e) {
      rethrow;
    }
  }


}