import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/home/domain/repository/cate_repository.dart';

import '../repository/user_info_repository.dart';

class GetCateByIdUseCase implements UseCase<CategoryEntity, int> {
  final CateRepository _cateRepository;

  GetCateByIdUseCase(this._cateRepository);

  @override
  Future<CategoryEntity> call({int? params}) async {
    try {
      return await _cateRepository.getCateById(params!);
    } catch (e) {
      rethrow;
    }
  }
}
