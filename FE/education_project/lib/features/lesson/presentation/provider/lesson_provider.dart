import 'package:dio/dio.dart';

import 'package:education_project/features/lesson/data/data_sources/lesson_api_service.dart';
import 'package:education_project/features/lesson/data/repository_impl/lesson_repository_impl.dart';
import 'package:education_project/features/lesson/domain/entities/lesson.dart';
import 'package:education_project/features/lesson/domain/usecase/get_lesson.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/injection_container.dart';



part 'lesson_provider.g.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final lessonApiServiceProvider = Provider<LessonApiService>((ref) {
  return s1<LessonApiService>();
});

final getLessonsUseCaseProvider = Provider<GetLessonsUseCase>((ref) {
  return s1<GetLessonsUseCase>();
});

@Riverpod(keepAlive: true)
Future<List<LessonEntity>?> lessons(Ref ref, int id) async {
  final getLessons = ref.read(getLessonsUseCaseProvider);
  final result = await getLessons.call(params:id);
  if (result is DataSuccess) {
    return result.data;
  } else {
    throw Exception('Failed to get Category');
  }
}