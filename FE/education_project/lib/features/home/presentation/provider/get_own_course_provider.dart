import 'package:dio/dio.dart';
import 'package:education_project/features/home/data/data_sources/courses_api_service.dart';
import 'package:education_project/features/home/data/repository_impl/course_repository_impl.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/usecases/get_cates.dart';
import 'package:education_project/features/home/domain/usecases/get_own_courses.dart';
import 'package:education_project/features/home/domain/usecases/get_own_courses_by_cate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/injection_container.dart';
import '../../data/data_sources/cate_api_service.dart';
import '../../data/repository_impl/cate_repository_impl.dart';
import '../../domain/usecases/get_user.dart';

part 'get_own_course_provider.g.dart';


final courseApiServiceProvider = Provider<CoursesApiService>((ref) {
  return s1<CoursesApiService>();
});

final getCourseUseCaseProvider = Provider<GetOwnCoursesUseCase>((ref) {
  return s1<GetOwnCoursesUseCase>();
});


@Riverpod(keepAlive: true)
Future<List<CourseEntity>?> coursesOwn(Ref ref) async {
  final getCourse = ref.read(getCourseUseCaseProvider);
  final result = await getCourse.call();
  if (result is DataSuccess) {
    return result.data;
  } else {
    throw Exception('Failed to coursé');
  }
}
