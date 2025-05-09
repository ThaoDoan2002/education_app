import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/courses/domain/repository/checkout_repository.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';

class CheckoutUseCase implements UseCase<DataState<String>,int>{
  final CheckoutRepository _checkoutRepository;

  CheckoutUseCase(this._checkoutRepository);

  @override
  Future<DataState<String>> call({int? params}) async {
    try {
      return await _checkoutRepository.checkoutCourse(params!);

    } catch (e) {
      rethrow;
    }
  }


}