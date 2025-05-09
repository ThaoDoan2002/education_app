import 'package:dio/dio.dart';
import 'package:education_project/features/home/data/data_sources/cate_api_service.dart';
import 'package:education_project/features/home/data/repository_impl/cate_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/injection_container.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_cate_by_id.dart';

part 'get_cate_by_ID_provider.g.dart';

@riverpod
Future<CategoryEntity?> category(Ref ref, int id) async {
  final getCateByIdUseCase = ref.watch(getCateByIdUseCaseProvider);
  final result =
      await getCateByIdUseCase.call(params: id); // Fetch category by ID
  if (result is DataSuccess) {
    return result.data;
  } else {
    throw Exception('Failed to get Category');
  }
}


final cateApiServiceProvider = Provider<CateApiService>((ref) {
  return s1<CateApiService>();
});

final getCateByIdUseCaseProvider = Provider<GetCateByIdUseCase>((ref) {
  return s1<GetCateByIdUseCase>();
});
