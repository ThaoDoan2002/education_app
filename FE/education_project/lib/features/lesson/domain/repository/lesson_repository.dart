
import 'package:education_project/features/lesson/domain/entities/lesson.dart';

abstract class LessonRepository {
  Future<List<LessonEntity>> getLesson(int id);

}
