import 'package:dio/dio.dart';
import 'package:education_project/features/forget_password/data/data_sources/forgot_password_api_service.dart';
import 'package:education_project/features/forget_password/data/repository_impl/forgot_password_repository_impl.dart';
import 'package:education_project/features/forget_password/domain/usecases/forget_password.dart';
import 'package:education_project/features/forget_password/domain/usecases/params/reset_password_param.dart';
import 'package:education_project/features/forget_password/presentation/provider/state/forget_password_state.dart';
import 'package:education_project/features/forget_password/presentation/provider/state/reset_password_state.dart';
import 'package:education_project/features/login/presentation/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/utils/injection_container.dart';
import '../../domain/usecases/reset_password.dart';

part 'forget_password_provider.g.dart';

@Riverpod(keepAlive: true)
class ForgetPasswordNotifier extends _$ForgetPasswordNotifier {
  @override
  ForgetPasswordState build() {
    return const ForgetPasswordInit();
  }

  // Phương thức xử lý đăng nhập
  Future<void> sendEmail(String params) async {
    // Đặt trạng thái loading
    state = const ForgetPasswordLoading();

    try {
      await ref.read(forgotPasswordUseCaseProvider).call(params: params);
      state = const ForgetPasswordDone();
    } catch (e) {
      print(e);
      if (e is DioException) {
        state = ForgetPasswordError(e);
      } else {
        state = ForgetPasswordError(DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Unknown error occurred'));
      }
    }
  }
}

@Riverpod(keepAlive: true)
class ResetPasswordNotifier extends _$ResetPasswordNotifier {
  @override
  ResetPasswordState build() {
    return const ResetPasswordInit();
  }

  // Phương thức xử lý đăng nhập
  Future<void> resetPassword(ResetPasswordBodyParams params) async {
    // Đặt trạng thái loading
    state = const ResetPasswordLoading();

    try {
      await ref.read(resetPasswordUseCaseProvider).call(params: params);
      state = const ResetPasswordDone();
    } catch (e) {
      print(e);
      if (e is DioException) {
        state = ResetPasswordError(e);
      } else {
        state = ResetPasswordError(DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Unknown error occurred'));
      }
    }
  }
}

final forgetPasswordApiServiceProvider =
    Provider<ForgotPasswordAPIService>((ref) {
  return s1<ForgotPasswordAPIService>();
});

final forgotPasswordUseCaseProvider = Provider<ForgetPasswordUseCase>((ref) {
  return s1<ForgetPasswordUseCase>();
});

final resetPasswordUseCaseProvider = Provider<ResetPasswordUseCase>((ref) {
  return s1<ResetPasswordUseCase>();
});
