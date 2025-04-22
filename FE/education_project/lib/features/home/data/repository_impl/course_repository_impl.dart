import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';

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
  Future<List<CourseEntity>> getOwnCoursesByCate(int id) async{
    try {
      final token = await TokenStorage().getToken();
      final httpResponse = await _coursesApiService.getOwnCoursesByCate(id,'Bearer $token');
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        print(httpResponse.response.data);
        final List<CourseEntity> courses = (httpResponse.response.data as List)
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
      final token = await TokenStorage().getToken();
      final httpResponse = await _coursesApiService.getCoursesByCate(cateId,'Bearer $token');
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

  @override
  Future<List<CourseEntity>> getOwnCourses() async{
    try {
      final token = await TokenStorage().getToken();
      final httpResponse = await _coursesApiService.getOwnCourses('Bearer $token');
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<CourseEntity> courses = (httpResponse.response.data as List)
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
}
