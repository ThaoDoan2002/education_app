import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';
import 'package:education_project/core/constants/constants.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final TokenStorage storage;

  final String tokenEndpoint = '$BASE_URL/o/token/';
  final String clientId = CLIENT_ID;
  final String clientSecret = CLIENT_SECRET;

  AuthInterceptor(this.dio, this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await storage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.getRefreshToken();

      if (refreshToken != null) {
        try {
          final refreshResponse = await dio.post(
            tokenEndpoint,
            data: {
              'grant_type': 'refresh_token',
              'refresh_token': refreshToken,
              'client_id': clientId,
              'client_secret': clientSecret,
            },
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );

          final newAccessToken = refreshResponse.data['access_token'];
          final newRefreshToken = refreshResponse.data['refresh_token'];

          await storage.saveTokens(newAccessToken, newRefreshToken);

          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await dio.fetch(retryOptions);
          return handler.resolve(retryResponse);
        } catch (e) {
          print('Lỗi khi refresh token: $e');
        }
      }
    }

    handler.next(err);
  }
}
