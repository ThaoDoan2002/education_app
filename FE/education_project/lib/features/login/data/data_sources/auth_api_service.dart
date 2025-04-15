import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'auth_api_service.g.dart';


@RestApi(baseUrl:BASE_URL)
abstract class AuthAPIService {
  factory AuthAPIService(Dio dio, {String baseUrl}) = _AuthAPIService;

  @POST("/o/token/")
  @FormUrlEncoded()
  Future<HttpResponse<dynamic>> login(
      @Field("grant_type") String grantType,
      @Field("client_id") String clientId,
      @Field("client_secret") String clientSecret,
      @Field("username") String username,
      @Field("password") String password,
      );


}
