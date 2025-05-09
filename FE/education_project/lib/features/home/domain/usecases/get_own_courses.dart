import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/home/domain/repository/cate_repository.dart';
import 'package:education_project/features/home/domain/repository/course_repository.dart';

import '../repository/user_info_repository.dart';


class GetOwnCoursesUseCase implements UseCase<DataState<List<CourseEntity>>,void>{
  final CourseRepository _courseRepository;

  GetOwnCoursesUseCase(this._courseRepository);

  @override
  Future<DataState<List<CourseEntity>>> call({void params}) async {
    try {
      return await _courseRepository.getOwnCourses();

    } catch (e) {
      rethrow;
    }
  }


}