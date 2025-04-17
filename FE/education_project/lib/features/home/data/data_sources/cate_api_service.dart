import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

import '../models/user.dart';

part 'cate_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class CateApiService {
  factory CateApiService(Dio dio, {String baseUrl}) = _CateApiService;

  @GET('/categories/{id}/')
  Future<HttpResponse<dynamic>> getCateById(@Path('id') int id);

  @GET('/categories/')
  Future<HttpResponse<dynamic>> getCates();
}
