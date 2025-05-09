import 'package:dio/dio.dart';
import 'package:education_project/features/login/domain/usecases/get_current_user.dart';
import 'package:education_project/features/login/presentation/provider/state/user_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/injection_container.dart';
import '../../data/data_sources/user_api_service.dart';

part 'user_provider.g.dart';


// Provider cho UserApiService để gọi các API của người dùng
final userApiServiceProvider = Provider<UserApiService>((ref) {
  return s1<UserApiService>();
});


// Provider cho UseCase lấy thông tin người dùng
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return s1<GetCurrentUserUseCase>();
});

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  UserState build() {
    return const UserInit(); // Trạng thái mặc định ban đầu là đang tải
  }

  // Hàm lấy thông tin người dùng
  Future<void> getCurrentUser() async {
    state = const UserLoading();
    try {
      final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);

      final result = await getCurrentUserUseCase();

      // Xử lý thành công
      if (result is DataSuccess) {
        state = UserDone(result.data!);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      state = UserError(
          DioException(error: e.toString(), requestOptions: RequestOptions()));
    }
  }
}
