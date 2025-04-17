


import 'package:education_project/features/home/domain/entities/category.dart';

abstract class CateRepository {
  Future<CategoryEntity> getCateById(int id);
  Future<List<CategoryEntity>> getCates();


}