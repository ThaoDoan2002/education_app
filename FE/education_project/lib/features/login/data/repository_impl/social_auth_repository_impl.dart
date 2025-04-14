import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';
import 'package:education_project/features/login/data/data_sources/social_auth_api_service.dart';
import 'package:education_project/features/login/domain/repository/social_auth_repository.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';

import '../../../../core/constants/constants.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/auth_api_service.dart';

class SocialAuthRepositoryImpl implements SocialAuthRepository {
  final Dio _dio;
  final TokenStorage tokenStorage;
  final SocialAuthAPIService _socialAuthAPIService;

  SocialAuthRepositoryImpl(this._dio, this.tokenStorage,
      this._socialAuthAPIService) {
    // Thêm interceptor để log request và response
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }

  @override
  Future<void> socialLogin(SocialLoginBodyParams params) async {
    try {
      final httpResponse =
      await _socialAuthAPIService.socialLogin({"idToken": params.idToken});
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
