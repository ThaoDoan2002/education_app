import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/constants.dart';
import '../models/user.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class UserApiService {
  factory UserApiService(Dio dio) = _UserApiService;

  @GET('/users/current_user/')
  Future<HttpResponse<UserModel>> getCurrentUser(@Header("Authorization") String token);
}