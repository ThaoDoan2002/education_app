import 'package:dio/dio.dart';
import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
part 'register_api_service.g.dart';


@RestApi(baseUrl:BASE_URL)
abstract class RegisterAPIService {
  factory RegisterAPIService(Dio dio, {String baseUrl}) = _RegisterAPIService;

  @POST("/users/")
  @MultiPart()
  Future<HttpResponse<dynamic>> register(
      @Part(name: "firstName") String fName,
      @Part(name: "lastName") String lName,
      @Part(name: "username") String username,
      @Part(name: "password") String password,
      @Part(name: "phone") String phone,
      @Part(name: "token") String token,
      );
}