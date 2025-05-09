
import 'package:education_project/features/lesson/domain/entities/lesson.dart';

import '../../../../core/resources/data_state.dart';

abstract class LessonRepository {
  Future<DataState<List<LessonEntity>>> getLesson(int id);

}
