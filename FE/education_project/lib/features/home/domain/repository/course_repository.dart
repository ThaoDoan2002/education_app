


import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';

abstract class CourseRepository {
  Future<List<CourseEntity>> getCourses();
  Future<List<CourseEntity>> getCoursesByCate(int cateId);



}