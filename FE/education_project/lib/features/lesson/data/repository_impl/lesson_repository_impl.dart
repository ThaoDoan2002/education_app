import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';

import 'package:education_project/features/home/data/data_sources/courses_api_service.dart';
import 'package:education_project/features/home/data/models/course.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/repository/course_repository.dart';
import 'package:education_project/features/lesson/data/models/lesson.dart';
import 'package:education_project/features/lesson/domain/entities/lesson.dart';

import '../../domain/repository/lesson_repository.dart';
import '../data_sources/lesson_api_service.dart';

  class LessonRepositoryImpl implements LessonRepository {
  final Dio _dio;
  final LessonApiService _lessonApiService;

  LessonRepositoryImpl(this._dio, this._lessonApiService) {
    // Thêm interceptor để log request và response
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }

  @override
  Future<List<LessonEntity>> getLesson(int id) async{
    try {
      final token = await TokenStorage().getToken();
      final httpResponse = await _lessonApiService.getLessons(id,'Bearer $token');
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<LessonEntity> lessons = (httpResponse.response.data as List)
            .map((lessonJson) => LessonModel.fromJson(lessonJson))
            .toList();
        return lessons;
      } else {
        throw Exception(
            'Failed to get courses: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;

    }
  }
}
