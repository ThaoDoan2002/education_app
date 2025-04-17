import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:education_project/features/home/data/data_sources/courses_api_service.dart';
import 'package:education_project/features/home/data/models/course.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/repository/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final Dio _dio;
  final CoursesApiService _coursesApiService;

  CourseRepositoryImpl(this._dio, this._coursesApiService) {
    // Thêm interceptor để log request và response
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }

  @override
  Future<List<CourseEntity>> getCourses() async{
    try {
      final httpResponse = await _coursesApiService.getCourses();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<CourseEntity> courses = (httpResponse.response.data['results'] as List)
            .map((courseJson) => CourseModel.fromJson(courseJson))
            .toList();
        return courses;
      } else {
        throw Exception(
            'Failed to get courses: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;

    }
  }

  @override
  Future<List<CourseEntity>> getCoursesByCate(int cateId) async{
    try {
      final httpResponse = await _coursesApiService.getCoursesByCate(cateId);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<CourseEntity> courses = (httpResponse.response.data as List)
            .map((courseJson) => CourseModel.fromJson(courseJson))
            .toList();
        return courses;
      } else {
        throw Exception(
            'Failed to get courses by cate: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;

    }
  }
}
