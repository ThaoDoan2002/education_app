import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/lesson/domain/entities/lesson.dart';

import '../../../../core/resources/data_state.dart';
import '../repository/lesson_repository.dart';


class GetLessonsUseCase implements UseCase<DataState<List<LessonEntity>>,int>{
  final LessonRepository _lessonRepository;

  GetLessonsUseCase(this._lessonRepository);

  @override
  Future<DataState<List<LessonEntity>>> call({int? params}) async {
    try {
      return await _lessonRepository.getLesson(params!);

    } catch (e) {
      rethrow;
    }
  }


}