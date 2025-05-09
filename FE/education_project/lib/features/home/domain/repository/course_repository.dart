import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/features/home/domain/entities/course.dart';

abstract class CourseRepository {
  Future<DataState<List<CourseEntity>>> getOwnCoursesByCate(int id);

  Future<DataState<List<CourseEntity>>> getOwnCourses();

  Future<DataState<List<CourseEntity>>> getCoursesByCate(int cateId);
}