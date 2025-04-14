import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;
part 'social_auth_api_service.g.dart';

@RestApi(baseUrl:BASE_URL)
abstract class SocialAuthAPIService {
  factory SocialAuthAPIService(Dio dio, {String baseUrl}) = _SocialAuthAPIService;

  @POST("/social_login/")
  @Headers(<String, dynamic>{"Content-Type": "application/json"})
  Future<HttpResponse<dynamic>> socialLogin(@Body() Map<String, dynamic> body);

}
