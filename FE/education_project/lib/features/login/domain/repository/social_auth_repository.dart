
import '../usecases/params/login_param.dart';

abstract class SocialAuthRepository {
  Future<void> socialLogin(SocialLoginBodyParams params);
}