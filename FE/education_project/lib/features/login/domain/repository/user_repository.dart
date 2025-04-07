import 'package:education_project/core/resouces/data_state.dart';
import 'package:education_project/features/login/domain/entities/user.dart';

abstract class UserRepository{
  Future<DataState<UserEntity>> getCurrentUser();
}