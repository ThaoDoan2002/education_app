import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/home/domain/repository/cate_repository.dart';

import '../repository/user_info_repository.dart';


class GetCatesUseCase implements UseCase<DataState<List<CategoryEntity>>,void>{
  final CateRepository _cateRepository;

  GetCatesUseCase(this._cateRepository);

  @override
  Future<DataState<List<CategoryEntity>>> call({void params}) async {
    try {
      return await _cateRepository.getCates();

    } catch (e) {
      rethrow;
    }
  }


}