import '../../domain/entities/list_courses.dart';
import 'course.dart';

class ListCoursesModel extends ListCourseEntity {
  const ListCoursesModel({
    required super.count,
    required super.next,
    required super.previous,
    required List<CourseModel> super.results,
  });

  factory ListCoursesModel.fromJson(Map<String, dynamic> json) {
    return ListCoursesModel(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
          ?.map((item) => CourseModel.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((course) {
        // Ép kiểu từ CourseEntity về CourseModel để dùng toJson
        if (course is CourseModel) {
          return course.toJson();
        } else {
          // fallback nếu không phải model
          return const CourseModel(
            id: 0,
            name: '',
            description: '',
            thumbnail: '',
            price: 0,
          ).toJson();
        }
      }).toList(),
    };
  }
}
