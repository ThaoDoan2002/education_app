import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/resouces/data_state.dart';
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
  Future<void> login(LoginParams params) async {
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

// @override
// Future<String?> login(LoginParams params) async {
//   final formData = FormData.fromMap({
//     'grant_type': 'password',
//     'client_id': CLIENT_ID,
//     'client_secret': CLIENT_SECRET,
//     'username': params.username,
//     'password': params.password,
//   });
//
//   final response = await _dio.post(
//     '$BASE_URL/o/token/',
//     data: formData,
//     options: Options(
//       contentType: Headers.formUrlEncodedContentType,
//     ),
//   );
//
//   if (response.statusCode == 200) {
//     final token = response.data['access_token'];
//     tokenStorage.saveToken(token);
//     return token;
//   } else {
//     throw Exception('Failed to login: ${response.statusMessage}');
//   }
// }
}
