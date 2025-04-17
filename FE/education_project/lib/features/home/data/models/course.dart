
import '../../domain/entities/course.dart';

class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.name,
    required super.description,
    required super.thumbnail,
    required super.price,
  });

  factory CourseModel.fromJson(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? "",
      description: map['description'] ?? "",
      thumbnail: map['thumbnail'] ?? "https://www.shutterstock.com/image-vector/default-ui-image-placeholder-wireframes-600nw-1037719192.jpg", //thay the hinh server
      price: map['price'] ?? 0
    );
  }
}