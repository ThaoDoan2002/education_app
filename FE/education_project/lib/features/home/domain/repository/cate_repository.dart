


import 'package:education_project/features/home/domain/entities/category.dart';

import '../../../../core/resources/data_state.dart';

abstract class CateRepository {
  Future<DataState<CategoryEntity>> getCateById(int id);
  Future<DataState<List<CategoryEntity>>> getCates();


}