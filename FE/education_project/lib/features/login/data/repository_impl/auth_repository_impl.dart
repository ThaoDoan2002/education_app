import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';
import 'package:education_project/features/login/data/data_sources/social_auth_api_service.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/constants.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final TokenStorage tokenStorage;
  final AuthAPIService _authApiService;

  AuthRepositoryImpl(this._dio, this._authApiService, this.tokenStorage) {
    // Thêm interceptor để log request và response
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }

  @override
  Future<void> login(LoginBodyParams params) async {
    try {
      final httpResponse = await _authApiService.login('password', CLIENT_ID,
          CLIENT_SECRET, params.username, params.password);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final token = httpResponse.response.data['access_token'];
        tokenStorage.saveToken(token);
      } else {
        throw Exception(
            'Failed to login: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }


}
