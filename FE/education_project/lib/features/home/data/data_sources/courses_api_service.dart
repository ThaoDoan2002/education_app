import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

import '../models/user.dart';

part 'courses_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class CoursesApiService {
  factory CoursesApiService(Dio dio, {String baseUrl}) = _CoursesApiService;

  @GET('/courses/')
  Future<HttpResponse<dynamic>> getCourses();

  @GET('/categories/{id}/courses/')
  Future<HttpResponse<dynamic>> getCoursesByCate(@Path('id') int cateId);
}
