import 'package:education_project/features/home/domain/entities/user.dart';

import '../../../../core/resources/data_state.dart';

abstract class UserRepository{
  Future<DataState<UserEntity>> getCurrentUser();
}