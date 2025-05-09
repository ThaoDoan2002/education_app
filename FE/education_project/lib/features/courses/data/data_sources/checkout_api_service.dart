import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'checkout_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class CheckoutApiService {
  factory CheckoutApiService(Dio dio, {String baseUrl}) = _CheckoutApiService;

  @POST('/payments/{course_id}/checkout/')
  Future<HttpResponse<dynamic>> checkoutCourse(
    @Path('course_id') int courseId
  );
}
