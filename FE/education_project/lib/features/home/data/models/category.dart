
import '../../domain/entities/category.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? "", // Chuỗi rỗng cho String nếu null

    );
  }
}