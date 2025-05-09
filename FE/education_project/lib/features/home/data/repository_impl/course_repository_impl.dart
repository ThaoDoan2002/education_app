import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/core/resources/data_state.dart';

import 'package:education_project/features/home/data/data_sources/courses_api_service.dart';
import 'package:education_project/features/home/data/models/course.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/repository/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CoursesApiService _coursesApiService;


  CourseRepositoryImpl( this._coursesApiService);

  @override
  Future<DataState<List<CourseEntity>>> getOwnCoursesByCate(int id) async{
    try {
      final httpResponse = await _coursesApiService.getOwnCoursesByCate(id);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        print(httpResponse.response.data);
        final List<CourseEntity> courses = (httpResponse.response.data as List)
            .map((courseJson) => CourseModel.fromJson(courseJson))
            .toList();
        return DataSuccess(courses);
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
  Future<DataState<List<CourseEntity>>> getCoursesByCate(int cateId) async{
    try {
      final httpResponse = await _coursesApiService.getCoursesByCate(cateId);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<CourseEntity> courses = (httpResponse.response.data as List)
            .map((courseJson) => CourseModel.fromJson(courseJson))
            .toList();
        return DataSuccess(courses);
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
  Future<DataState<List<CourseEntity>>> getOwnCourses() async{
    try {
      final httpResponse = await _coursesApiService.getOwnCourses();
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<CourseEntity> courses = (httpResponse.response.data as List)
            .map((courseJson) => CourseModel.fromJson(courseJson))
            .toList();
        return DataSuccess(courses);
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