import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/features/home/data/data_sources/user_info_api_service.dart';
import 'package:education_project/features/home/data/models/user.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/home/domain/repository/user_info_repository.dart';



class UserInfoRepositoryImpl implements UserInfoRepository {
  final UserInfoApiService _userInfoApiService;


  UserInfoRepositoryImpl(this._userInfoApiService);



  @override
  Future<DataState<UserEntity>> getUser() async{
    try {

      final httpResponse = await _userInfoApiService.getUser();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final user = UserModel.fromJson(httpResponse.response.data);
        return DataSuccess(user);
      } else {
        return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }


}
