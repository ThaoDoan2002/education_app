

import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/features/home/domain/entities/user.dart';

abstract class UserInfoRepository {
  Future<DataState<UserEntity>> getUser();

}