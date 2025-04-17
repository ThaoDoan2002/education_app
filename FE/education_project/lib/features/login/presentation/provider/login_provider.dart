import 'package:dio/dio.dart';
import 'package:education_project/features/login/data/data_sources/auth_api_service.dart';
import 'package:education_project/features/login/data/data_sources/social_auth_api_service.dart';
import 'package:education_project/features/login/domain/usecases/params/login_param.dart';
import 'package:education_project/features/login/presentation/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repository_impl/auth_repository_impl.dart';
import '../../data/repository_impl/social_auth_repository_impl.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/social_login.dart';
import 'state/login_state.dart';
part 'login_provider.g.dart';

@Riverpod(keepAlive: true)
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() {
    return const LoginInit();
  }

  // Phương thức xử lý đăng nhập
  Future<void> login(LoginBodyParams params) async {
    // Đặt trạng thái loading
    state = const LoginLoading();

    try {
      await ref.read(loginUseCaseProvider).call(params: params);
      state = const LoginDone();
      print('hiiiiiiiiiiiii');

    } catch (e) {
      print(e);
      if (e is DioException) {
        state = LoginError(e);
      } else {
        state = LoginError(DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Unknown error occurred'));
      }
    }
  }
}

@Riverpod(keepAlive: true)
class SocialLoginNotifier extends _$SocialLoginNotifier {
  @override
  LoginState build() {
    return const LoginInit();
  }

  // Phương thức xử lý đăng nhập
  Future<void> socialLogin(SocialLoginBodyParams params) async {
    // Đặt trạng thái loading
    state = const LoginLoading();

    try {
      await ref.read(socialLoginUseCaseProvider).call(params: params);
      state = const LoginDone();
    } catch (e) {
      print(e);
      if (e is DioException) {
        state = LoginError(e);
      } else {
        state = LoginError(DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Unknown error occurred'));
      }
    }
  }
}

final authApiServiceProvider = Provider<AuthAPIService>((ref) {
  final dio = ref.read(dioProvider);
  return AuthAPIService(dio);
});

final socialAuthApiServiceProvider = Provider<SocialAuthAPIService>((ref) {
  final dio = ref.read(dioProvider);
  return SocialAuthAPIService(dio);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final dio = Dio();
  final tokenStorage = ref.read(tokenStorageProvider);
  final authApiService = ref.read(authApiServiceProvider);

  final authRepository = AuthRepositoryImpl(dio, authApiService, tokenStorage);
  return LoginUseCase(authRepository);
});

final socialLoginUseCaseProvider = Provider<SocialLoginUseCase>((ref) {
  final dio = Dio();
  final tokenStorage = ref.read(tokenStorageProvider);
  final socialAuthApiService = ref.read(socialAuthApiServiceProvider);

  final socialAuthRepository = SocialAuthRepositoryImpl(dio, tokenStorage, socialAuthApiService );
  return SocialLoginUseCase(socialAuthRepository);
});


