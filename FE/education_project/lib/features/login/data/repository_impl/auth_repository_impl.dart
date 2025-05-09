import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../config/storage/token_storage.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/auth_api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthAPIService _authApiService;

  AuthRepositoryImpl(this._authApiService);

  @override
  Future<void> login(LoginBodyParams params) async {
    try {
      final httpResponse = await _authApiService.login('password', CLIENT_ID,
          CLIENT_SECRET, params.username, params.password);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final token = httpResponse.response.data['access_token'];
        final refreshToken = httpResponse.response.data['refresh_token'];
        await TokenStorage().saveTokens(token, refreshToken);
      } else {
        throw Exception(
            'Failed to login: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
