import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/home/domain/entities/user.dart';

import '../repository/user_info_repository.dart';


class GetUserUseCase implements UseCase<UserEntity,void>{
  final UserInfoRepository _userInfoRepository;

  GetUserUseCase(this._userInfoRepository);

  @override
  Future<UserEntity> call({void params}) async {
    try {
      return await _userInfoRepository.getUser();

    } catch (e) {
      rethrow;
    }
  }


}