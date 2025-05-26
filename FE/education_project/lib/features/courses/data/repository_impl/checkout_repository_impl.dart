import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/features/courses/data/data_sources/checkout_api_service.dart';
import 'package:education_project/features/courses/domain/repository/checkout_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutApiService _checkoutApiService;

  CheckoutRepositoryImpl(this._checkoutApiService);

  @override
  Future<DataState<String>> checkoutCourse(int courseId) async {
    try {
      final deviceToken = await FirebaseMessaging.instance.getToken();
      final httpResponse = await _checkoutApiService.checkoutCourse(
        courseId,
        {'device_token': deviceToken},
      );
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.response.data['checkout_url']);
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
