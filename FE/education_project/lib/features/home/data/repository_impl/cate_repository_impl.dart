import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:education_project/features/home/data/data_sources/cate_api_service.dart';
import 'package:education_project/features/home/data/models/category.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/repository/cate_repository.dart';

class CateRepositoryImpl implements CateRepository {
  final Dio _dio;
  final CateApiService _cateApiService;

  CateRepositoryImpl(this._dio, this._cateApiService) {
    // Thêm interceptor để log request và response
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }

  @override
  Future<CategoryEntity> getCateById(int id) async {
    try {
      final httpResponse = await _cateApiService.getCateById(id);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return CategoryModel.fromJson(httpResponse.response.data);
      } else {
        throw Exception(
            'Failed to get category: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryEntity>> getCates() async {
    try {
      final httpResponse = await _cateApiService.getCates();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<CategoryEntity> categories = (httpResponse.response.data as List)
            .map((categoryJson) => CategoryModel.fromJson(categoryJson))
            .toList();
        return categories;
      } else {
        throw Exception(
            'Failed to get categories: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;

    }
  }
}
