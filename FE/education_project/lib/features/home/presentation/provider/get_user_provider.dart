import 'package:dio/dio.dart';
import 'package:education_project/features/home/data/data_sources/user_info_api_service.dart';
import 'package:education_project/features/home/data/repository_impl/user_info_repository_impl.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/usecases/get_user.dart';

part 'get_user_provider.g.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final getUserApiServiceProvider = Provider<UserInfoApiService>((ref) {
  final dio = ref.read(dioProvider);
  return UserInfoApiService(dio);
});

final getUserUseCaseProvider = Provider<GetUserUseCase>((ref) {
  final dio = ref.read(dioProvider);
  final apiService = ref.read(getUserApiServiceProvider);
  final repository = UserInfoRepositoryImpl(dio, apiService);
  return GetUserUseCase(repository);
});

@Riverpod(keepAlive: true)
Future<UserEntity> user(Ref ref) async {
  final getUserUseCase = ref.read(getUserUseCaseProvider);
  return await getUserUseCase.call();
}
