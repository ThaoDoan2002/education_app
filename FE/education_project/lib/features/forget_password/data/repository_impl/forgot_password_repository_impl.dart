import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/features/forget_password/data/data_sources/forgot_password_api_service.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';

import '../../domain/usecases/params/reset_password_param.dart';


class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final Dio _dio;
  final ForgotPasswordAPIService _forgotPasswordAPIService;

  ForgotPasswordRepositoryImpl(this._dio, this._forgotPasswordAPIService) {
    // Thêm interceptor để log request và response
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }


  @override
  Future<void> sendEmail(String email) async{
    try {
      final httpResponse = await _forgotPasswordAPIService.sendEmail({'email': email});
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        print('OKE');
      } else {
        throw Exception(
            'Failed to send email: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordBodyParams params) async{
    try {
      final httpResponse = await _forgotPasswordAPIService.resetPassword({'uid': params.uid,
        'token': params.token,
        'new_password': params.password,});
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        print('OKE');
      } else {
        throw Exception(
            'Failed to reset password: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

}
