import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/forget_password/domain/usecases/params/reset_password_param.dart';
import 'package:education_project/features/register/domain/repository/register_repository.dart';
import 'package:education_project/features/register/domain/usecases/params/register_param.dart';


class RegisterUseCase implements UseCase<void,RegisterBodyParams>{
  final RegisterRepository _registerRepository;

  RegisterUseCase(this._registerRepository);

  @override
  Future<void> call({RegisterBodyParams? params}) async {
    try {
      await _registerRepository.register(params!);

    } catch (e) {
      rethrow;
    }
  }


}