import 'package:dio/dio.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/usecases/get_cates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/injection_container.dart';
import '../../data/data_sources/cate_api_service.dart';
import '../../data/repository_impl/cate_repository_impl.dart';
import '../../domain/usecases/get_user.dart';

part 'get_cates_provider.g.dart';


final cateApiServiceProvider = Provider<CateApiService>((ref) {
  return s1<CateApiService>();
});

final getCatesUseCaseProvider = Provider<GetCatesUseCase>((ref) {
 return s1<GetCatesUseCase>();
});

@Riverpod(keepAlive: true)
Future<List<CategoryEntity>?> categories(Ref ref) async {
  final getCates = ref.read(getCatesUseCaseProvider);
  final result =  await getCates.call();
  if (result is DataSuccess) {
    return result.data;
  } else {
    throw Exception('Failed to get List Categories');
  }
}
