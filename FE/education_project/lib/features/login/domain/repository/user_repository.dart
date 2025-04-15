import 'package:education_project/features/login/domain/entities/user.dart';

import '../../../../core/resources/data_state.dart';

abstract class UserRepository{
  Future<DataState<UserEntity>> getCurrentUser();
}