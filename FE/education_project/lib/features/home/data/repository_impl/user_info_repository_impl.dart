import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';
import 'package:education_project/features/forget_password/data/data_sources/forgot_password_api_service.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/home/data/data_sources/user_info_api_service.dart';
import 'package:education_project/features/home/data/models/user.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/home/domain/repository/user_info_repository.dart';



class UserInfoRepositoryImpl implements UserInfoRepository {
  final Dio _dio;
  final UserInfoApiService _userInfoApiService;

  UserInfoRepositoryImpl(this._dio, this._userInfoApiService) {
    // Thêm interceptor để log request và response
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }


  @override
  Future<UserEntity> getUser() async{
    try {
      TokenStorage storage = TokenStorage();
      final token = await storage.getToken();
      final httpResponse = await _userInfoApiService.getUser('Bearer $token');
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return UserModel.fromJson(httpResponse.response.data);
      } else {
        throw Exception(
            'Failed to get user: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }


}
