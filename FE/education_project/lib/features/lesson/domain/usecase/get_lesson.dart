import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/home/domain/repository/cate_repository.dart';
import 'package:education_project/features/home/domain/repository/course_repository.dart';
import 'package:education_project/features/lesson/domain/entities/lesson.dart';

import '../repository/lesson_repository.dart';


class GetLessonsUseCase implements UseCase<List<LessonEntity>,int>{
  final LessonRepository _lessonRepository;

  GetLessonsUseCase(this._lessonRepository);

  @override
  Future<List<LessonEntity>> call({int? params}) async {
    try {
      return await _lessonRepository.getLesson(params!);

    } catch (e) {
      rethrow;
    }
  }


}