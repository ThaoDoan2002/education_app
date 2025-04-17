

import 'package:education_project/features/home/domain/entities/user.dart';

abstract class UserInfoRepository {
  Future<UserEntity> getUser();

}