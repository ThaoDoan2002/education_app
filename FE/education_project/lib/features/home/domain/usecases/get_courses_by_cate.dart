import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/home/domain/repository/cate_repository.dart';
import 'package:education_project/features/home/domain/repository/course_repository.dart';

import '../repository/user_info_repository.dart';


class GetCoursesByCateUseCase implements UseCase<DataState<List<CourseEntity>>,int>{
  final CourseRepository _courseRepository;

  GetCoursesByCateUseCase(this._courseRepository);

  @override
  Future<DataState<List<CourseEntity>>> call({int? params}) async {
    try {
      return await _courseRepository.getCoursesByCate(params!);

    } catch (e) {
      rethrow;
    }
  }


}