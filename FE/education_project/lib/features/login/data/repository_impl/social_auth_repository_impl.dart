import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/features/login/data/data_sources/social_auth_api_service.dart';
import 'package:education_project/features/login/domain/repository/social_auth_repository.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../config/storage/token_storage.dart';


class SocialAuthRepositoryImpl implements SocialAuthRepository {
  final SocialAuthAPIService _socialAuthAPIService;


  SocialAuthRepositoryImpl(this._socialAuthAPIService);

  @override
  Future<void> socialLogin(SocialLoginBodyParams params) async {
    try {

      final httpResponse =
      await _socialAuthAPIService.socialLogin({"idToken": params.idToken});

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
