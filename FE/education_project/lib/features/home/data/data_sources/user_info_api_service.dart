import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

import '../models/user.dart';

part 'user_info_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class UserInfoApiService {
  factory UserInfoApiService(Dio dio, {String baseUrl}) = _UserInfoApiService;

  @GET('/users/current_user/')
  Future<HttpResponse<dynamic>> getUser();
}
