import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/features/forget_password/data/data_sources/forgot_password_api_service.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/register/data/data_sources/register_api_service.dart';
import 'package:education_project/features/register/domain/usecases/params/register_param.dart';

import '../../domain/repository/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterAPIService _registerAPIService;

  RegisterRepositoryImpl(this._registerAPIService);

  @override
  Future<void> register(RegisterBodyParams params) async {
    try {
      final httpResponse = await _registerAPIService.register(
          params.fName,
          params.lName,
          params.username,
          params.password,
          params.phone,
          params.token);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        print('OKE');
      } else {
        throw Exception(
            'Failed to register: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      print('failllllllllllll');
      print(e);

      rethrow;
    }
  }
}
