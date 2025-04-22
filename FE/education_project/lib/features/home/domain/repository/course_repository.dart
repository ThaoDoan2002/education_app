import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';

abstract class CourseRepository {
  Future<List<CourseEntity>> getOwnCoursesByCate(int id);

  Future<List<CourseEntity>> getOwnCourses();

  Future<List<CourseEntity>> getCoursesByCate(int cateId);
}
