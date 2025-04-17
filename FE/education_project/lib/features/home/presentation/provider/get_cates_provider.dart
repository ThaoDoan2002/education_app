import 'package:dio/dio.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/usecases/get_cates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/data_sources/cate_api_service.dart';
import '../../data/repository_impl/cate_repository_impl.dart';
import '../../domain/usecases/get_user.dart';

part 'get_cates_provider.g.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final cateApiServiceProvider = Provider<CateApiService>((ref) {
  final dio = ref.read(dioProvider);
  return CateApiService(dio);
});

final getCatesUseCaseProvider = Provider<GetCatesUseCase>((ref) {
  final dio = ref.read(dioProvider);
  final apiService = ref.read(cateApiServiceProvider);
  final repository = CateRepositoryImpl(dio, apiService);
  return GetCatesUseCase(repository);
});

@Riverpod(keepAlive: true)
Future<List<CategoryEntity>> categories(Ref ref) async {
  final getCates = ref.read(getCatesUseCaseProvider);
  return await getCates.call();
}
