import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;


part 'video_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class VideoApiService {
  factory VideoApiService(Dio dio, {String baseUrl}) = _VideoApiService;

  @GET('/lessons/{id}/video/')
  Future<HttpResponse<dynamic>> getVideo(@Path('id') int lessonId);
}

