import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/core/resources/data_state.dart';

import 'package:education_project/features/home/data/data_sources/cate_api_service.dart';
import 'package:education_project/features/home/data/models/category.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/repository/cate_repository.dart';

class CateRepositoryImpl implements CateRepository {
  final CateApiService _cateApiService;

  CateRepositoryImpl(this._cateApiService);

  @override
  Future<DataState<CategoryEntity>> getCateById(int id) async {
    try {
      final httpResponse = await _cateApiService.getCateById(id);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        CategoryEntity cate =
            CategoryModel.fromJson(httpResponse.response.data);
        return DataSuccess(cate);
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

  @override
  Future<DataState<List<CategoryEntity>>> getCates() async {
    try {
      final httpResponse = await _cateApiService.getCates();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<CategoryEntity> categories =
            (httpResponse.response.data as List)
                .map((categoryJson) => CategoryModel.fromJson(categoryJson))
                .toList();
        return DataSuccess(categories);
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
