import 'package:dio/dio.dart';
import 'package:education_project/features/home/data/data_sources/cate_api_service.dart';
import 'package:education_project/features/home/data/repository_impl/cate_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/category.dart';
import '../../domain/usecases/get_cate_by_id.dart';

part 'get_cate_by_ID_provider.g.dart';

@riverpod
Future<CategoryEntity?> category(Ref ref, int id) async {
  final getCateByIdUseCase = ref.watch(getCateByIdUseCaseProvider);
  final category =
      await getCateByIdUseCase.call(params: id); // Fetch category by ID
  return category;
}

final dioProvider = Provider<Dio>((ref) => Dio());

final cateApiServiceProvider = Provider<CateApiService>((ref) {
  final dio = ref.read(dioProvider);
  return CateApiService(dio);
});

final getCateByIdUseCaseProvider = Provider<GetCateByIdUseCase>((ref) {
  final dio = ref.read(dioProvider);
  final apiService = ref.read(cateApiServiceProvider);
  final repository = CateRepositoryImpl(dio, apiService);
  return GetCateByIdUseCase(repository);
});
