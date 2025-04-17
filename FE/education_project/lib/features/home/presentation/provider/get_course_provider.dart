import 'package:dio/dio.dart';
import 'package:education_project/features/home/data/data_sources/courses_api_service.dart';
import 'package:education_project/features/home/data/repository_impl/course_repository_impl.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/usecases/get_cates.dart';
import 'package:education_project/features/home/domain/usecases/get_courses.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/data_sources/cate_api_service.dart';
import '../../data/repository_impl/cate_repository_impl.dart';
import '../../domain/usecases/get_user.dart';

part 'get_course_provider.g.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final courseApiServiceProvider = Provider<CoursesApiService>((ref) {
  final dio = ref.read(dioProvider);
  return CoursesApiService(dio);
});

final getCourseUseCaseProvider = Provider<GetCoursesUseCase>((ref) {
  final dio = ref.read(dioProvider);
  final apiService = ref.read(courseApiServiceProvider);
  final repository = CourseRepositoryImpl(dio, apiService);
  return GetCoursesUseCase(repository);
});

@Riverpod(keepAlive: true)
Future<List<CourseEntity>> courses(Ref ref) async {
  final getCourse = ref.read(getCourseUseCaseProvider);
  return await getCourse.call();
}
