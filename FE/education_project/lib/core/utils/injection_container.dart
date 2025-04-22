import 'package:dio/dio.dart';
import 'package:education_project/features/courses/data/repository_impl/checkout_repository_impl.dart';
import 'package:get_it/get_it.dart';

import '../../features/courses/data/data_sources/checkout_api_service.dart';
import '../../features/courses/domain/repository/checkout_repository.dart';
import '../../features/courses/domain/usecases/checkout.dart';

final s1 = GetIt.instance;

Future<void> initializeDependencies() async {
  s1.registerSingleton<Dio>(Dio());

  s1.registerSingleton<CheckoutApiService>(CheckoutApiService(s1()));

  s1.registerSingleton<CheckoutRepository>(CheckoutRepositoryImpl(s1()));

  s1.registerSingleton<CheckoutUseCase>(CheckoutUseCase(s1()));
  
}
