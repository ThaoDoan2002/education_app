import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'forgot_password_api_service.g.dart';


@RestApi(baseUrl:BASE_URL)
abstract class ForgotPasswordAPIService {
  factory ForgotPasswordAPIService(Dio dio, {String baseUrl}) = _ForgotPasswordAPIService;

  @POST("/request-reset-password/")
  @Headers(<String, dynamic>{"Content-Type": "application/json"})
  Future<HttpResponse<dynamic>> sendEmail(@Body() Map<String, dynamic> body);

  @POST("/reset-password/")
  @Headers(<String, dynamic>{"Content-Type": "application/json"})
  Future<HttpResponse<dynamic>> resetPassword(@Body() Map<String, dynamic> body);

}