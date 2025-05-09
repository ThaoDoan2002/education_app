import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/login/domain/repository/user_repository.dart';

import '../../../../core/resources/data_state.dart';

class GetCurrentUserUseCase implements UseCase<DataState<UserEntity>, void>{
  final UserRepository _userRepository;
  GetCurrentUserUseCase(this._userRepository);
  @override
  Future<DataState<UserEntity>> call({void params}) {
    return _userRepository.getCurrentUser();
  }
}