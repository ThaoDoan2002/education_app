import 'package:dio/dio.dart';
import 'package:education_project/features/home/data/data_sources/courses_api_service.dart';
import 'package:education_project/features/home/data/repository_impl/course_repository_impl.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/usecases/get_cates.dart';
import 'package:education_project/features/home/domain/usecases/get_own_courses_by_cate.dart';
import 'package:education_project/features/home/domain/usecases/get_courses_by_cate.dart';
import 'package:education_project/features/lesson/data/data_sources/lesson_api_service.dart';
import 'package:education_project/features/lesson/data/repository_impl/lesson_repository_impl.dart';
import 'package:education_project/features/lesson/domain/entities/lesson.dart';
import 'package:education_project/features/lesson/domain/usecase/get_lesson.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';



part 'lesson_provider.g.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final lessonApiServiceProvider = Provider<LessonApiService>((ref) {
  final dio = ref.read(dioProvider);
  return LessonApiService(dio);
});

final getLessonsUseCaseProvider = Provider<GetLessonsUseCase>((ref) {
  final dio = ref.read(dioProvider);
  final apiService = ref.read(lessonApiServiceProvider);
  final repository = LessonRepositoryImpl(dio, apiService);
  return GetLessonsUseCase(repository);
});

@Riverpod(keepAlive: true)
Future<List<LessonEntity>> lessons(Ref ref, int id) async {
  final getLessons = ref.read(getLessonsUseCaseProvider);
  return await getLessons.call(params:id);
}