import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';

import '../repository/auth_repository.dart';

class LoginUseCase implements UseCase<void,LoginParams>{
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<void> call({LoginParams? params}) async {
    try {
      await _authRepository.login(params!);

    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }


}