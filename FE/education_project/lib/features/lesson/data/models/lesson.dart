
import '../../domain/entities/lesson.dart';

class LessonModel extends LessonEntity {
  const LessonModel({
    required int id,
    required String title,
    required String description,
  }) : super(
    id: id,
    title: title,
    description: title,

  );

  factory LessonModel.fromJson(Map<String, dynamic> map) {
    return LessonModel(
      id: map['id'] ?? 0,
      title: map['title'] ?? "",
      description: map['description'] ?? "",
    );
  }
}