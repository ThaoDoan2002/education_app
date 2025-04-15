import 'package:dio/dio.dart';
import 'package:education_project/features/login/domain/entities/user.dart';
import 'package:education_project/features/login/domain/usecases/get_current_user.dart';
import 'package:education_project/features/login/presentation/provider/state/user_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../config/storage/token_storage.dart';
import '../../../../core/resources/data_state.dart';
import '../../data/data_sources/user_api_service.dart';
import '../../data/repository_impl/user_repository_impl.dart';
import '../../domain/repository/user_repository.dart';

part 'user_provider.g.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// Provider cho UserApiService để gọi các API của người dùng
final userApiServiceProvider = Provider<UserApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return UserApiService(dio);
});

// Provider cho UserRepository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userApiService = ref.watch(userApiServiceProvider);
  final tokenStorage = ref.read(tokenStorageProvider);
  return UserRepositoryImpl(userApiService, tokenStorage);
});

// Provider cho UseCase lấy thông tin người dùng
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return GetCurrentUserUseCase(userRepository);
});

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  UserState build() {
    return const UserInit(); // Trạng thái mặc định ban đầu là đang tải
  }

  // Hàm lấy thông tin người dùng
  Future<void> getCurrentUser() async {
    state = const UserLoading(); // Chuyển sang trạng thái đang tải
    try {
      // Sử dụng UseCase để lấy thông tin người dùng
      final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);

      final result = await getCurrentUserUseCase();

      // Xử lý thành công
      if (result is DataSuccess) {
        state = UserDone(result.data!);
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      state = UserError(DioException(error: e.toString(), requestOptions: RequestOptions()));
    }
  }
}


