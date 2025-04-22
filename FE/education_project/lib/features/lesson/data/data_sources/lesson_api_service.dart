import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;


part 'lesson_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class LessonApiService {
  factory LessonApiService(Dio dio, {String baseUrl}) = _LessonApiService;

  @GET('/courses/{id}/lessons/')
  Future<HttpResponse<dynamic>> getLessons(@Path('id') int courseId,
      @Header('Authorization') String token);
}

