import 'package:education_project/features/courses/data/data_sources/checkout_api_service.dart';
import 'package:education_project/features/courses/domain/usecases/checkout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/injection_container.dart';

part 'checkout_provider.g.dart';

@riverpod
Future<String?> checkout(Ref ref, int courseId) async {
  final usecase = ref.watch(checkoutUseCaseProvider);
  final result = await usecase.call(params: courseId);
  if (result is DataSuccess) {
    return result.data;
  } else {
    print(result.error?.message);
    throw Exception('Failed to checkout');
  }
}


final checkoutApiServiceProvider = Provider<CheckoutApiService>((ref) {
  return s1<CheckoutApiService>();
});

final checkoutUseCaseProvider = Provider<CheckoutUseCase>((ref) {
  return s1<CheckoutUseCase>();
});
