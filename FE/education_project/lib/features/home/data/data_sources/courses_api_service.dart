import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

import '../models/user.dart';

part 'courses_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class CoursesApiService {
  factory CoursesApiService(Dio dio, {String baseUrl}) = _CoursesApiService;

  @GET('/categories/{id}/paid-courses/')
  Future<HttpResponse<dynamic>> getOwnCoursesByCate(
      @Path('id') int cateId,);

  @GET('/courses/')
  Future<HttpResponse<dynamic>> getOwnCourses();


  @GET('/categories/{id}/courses/')
  Future<HttpResponse<dynamic>> getCoursesByCate(
      @Path('id') int cateId,
      );

  @GET('/courses/unpaid-courses')
  Future<HttpResponse<dynamic>> getUnpaidCourses(
      @Query('page') int page,
      @Query('cateID') int cateId,
      );
}