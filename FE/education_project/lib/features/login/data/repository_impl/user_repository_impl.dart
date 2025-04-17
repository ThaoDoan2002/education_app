import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/features/login/data/data_sources/user_api_service.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/login/domain/repository/user_repository.dart';

import '../../../../config/storage/token_storage.dart';
import '../../../../core/resources/data_state.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApiService _userApiService;
  final TokenStorage _tokenStorage;

  UserRepositoryImpl(this._userApiService, this._tokenStorage);

  @override
  Future<DataState<UserEntity>> getCurrentUser() async {
    try {
      String? token = '';
      await _tokenStorage.getToken().then((t) {
        token = t;
      });
      if (token == '') {
        return DataFailed(DioException(
            error: 'No token found', requestOptions: RequestOptions(path: '')));
      }

      final httpResponse = await _userApiService.getCurrentUser(
          'Bearer ${token!}');

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        print('${httpResponse.data}');
        return DataSuccess(httpResponse.data);
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
