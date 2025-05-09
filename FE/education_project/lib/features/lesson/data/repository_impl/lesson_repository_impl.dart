import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/features/lesson/data/models/lesson.dart';
import 'package:education_project/features/lesson/domain/entities/lesson.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repository/lesson_repository.dart';
import '../data_sources/lesson_api_service.dart';

  class LessonRepositoryImpl implements LessonRepository {
  final LessonApiService _lessonApiService;


  LessonRepositoryImpl(this._lessonApiService);

  @override
  Future<DataState<List<LessonEntity>>> getLesson(int id) async{
    try {
      final httpResponse = await _lessonApiService.getLessons(id);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<LessonEntity> lessons = (httpResponse.response.data as List)
            .map((lessonJson) => LessonModel.fromJson(lessonJson))
            .toList();
        return DataSuccess(lessons);
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
