import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';
import 'package:education_project/features/courses/data/data_sources/checkout_api_service.dart';
import 'package:education_project/features/courses/domain/repository/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutApiService _checkoutApiService;

  CheckoutRepositoryImpl(this._checkoutApiService);

  @override
  Future<String> checkoutCourse(int courseId) async {
    try {
      final token = await TokenStorage().getToken();
      final httpResponse =
          await _checkoutApiService.checkoutCourse(courseId, 'Bearer $token');
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return httpResponse.response.data['checkout_url'];
      } else {
        throw Exception(
            'Failed to checkout: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
