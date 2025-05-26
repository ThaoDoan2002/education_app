import 'package:dio/dio.dart';
import 'package:education_project/features/home/data/data_sources/courses_api_service.dart';
import 'package:education_project/features/home/data/repository_impl/course_repository_impl.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/usecases/get_courses_by_cate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/injection_container.dart';
import 'get_user_provider.dart';


part 'get_courses_by_cate_provider.g.dart';


final courseApiServiceProvider = Provider<CoursesApiService>((ref) {
  return s1<CoursesApiService>();
});

final getCourseByCateUseCaseProvider = Provider<GetCoursesByCateUseCase>((ref) {
  return s1<GetCoursesByCateUseCase>();
});

@Riverpod(keepAlive: true)
Future<List<CourseEntity>?> coursesByCate(Ref ref, int id) async {
  // final userInfo = ref.watch(userProvider);
  final getCoursesBycate = ref.read(getCourseByCateUseCaseProvider);
  final result = await getCoursesBycate.call(params:id);
  if (result is DataSuccess) {
    return result.data;
  } else {
    throw Exception('Failed to get courses');
  }
}