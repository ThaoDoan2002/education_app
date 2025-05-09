import 'package:dio/dio.dart';
import 'package:education_project/features/home/data/data_sources/user_info_api_service.dart';
import 'package:education_project/features/home/data/repository_impl/user_info_repository_impl.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../config/storage/token_storage.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/injection_container.dart';
import '../../domain/usecases/get_user.dart';

part 'get_user_provider.g.dart';

final getUserApiServiceProvider = Provider<UserInfoApiService>((ref) {
  return s1<UserInfoApiService>();
});

final getUserUseCaseProvider = Provider<GetUserUseCase>((ref) {
  return s1<GetUserUseCase>();
});

final tokenProvider = StateProvider<String?>((ref) => null);


@Riverpod(keepAlive: true)
Future<UserEntity?> user(Ref ref) async {
  final token = ref.watch(tokenProvider); // Theo dõi token từ provider
  if (token == null) {
    throw Exception('No token found');
  }
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  final result = await getUserUseCase.call();
  if (result is DataSuccess) {
    return result.data;
  } else {
    throw Exception('Failed to load user');
  }
}
