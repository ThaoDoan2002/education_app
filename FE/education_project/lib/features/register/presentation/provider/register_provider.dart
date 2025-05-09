import 'package:dio/dio.dart';
import 'package:education_project/features/login/presentation/provider/user_provider.dart';
import 'package:education_project/features/register/data/repository_impl/register_repository_impl.dart';
import 'package:education_project/features/register/domain/usecases/params/register_param.dart';
import 'package:education_project/features/register/presentation/provider/state/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/injection_container.dart';
import '../../data/data_sources/register_api_service.dart';
import '../../domain/usecases/register.dart';
part 'register_provider.g.dart';

@Riverpod(keepAlive: true)
class RegisterNotifier extends _$RegisterNotifier {
  @override
  RegisterState build() {
    return const RegisterInit();
  }

  // Phương thức xử lý đăng nhập
  Future<void> register(RegisterBodyParams params) async {
    // Đặt trạng thái loading
    state = const RegisterLoading();

    try {
      await ref.read(registerUseCaseProvider).call(params: params);
      state = const RegisterDone();
    } catch (e) {
      print(e);
      if (e is DioException) {
        state = RegisterError(e);
      } else {
        state = RegisterError(DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Unknown error occurred'));
      }
    }
  }
}



final registerApiServiceProvider = Provider<RegisterAPIService>((ref) {
  return s1<RegisterAPIService>();
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return s1<RegisterUseCase>();
});



