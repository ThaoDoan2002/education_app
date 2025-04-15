import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';

import '../repository/auth_repository.dart';
import '../repository/social_auth_repository.dart';

class SocialLoginUseCase implements UseCase<void,SocialLoginBodyParams>{
  final SocialAuthRepository _socialAuthRepository;

  SocialLoginUseCase(this._socialAuthRepository);

  @override
  Future<void> call({SocialLoginBodyParams? params}) async {
    try {
      await _socialAuthRepository.socialLogin(params!);
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }
}