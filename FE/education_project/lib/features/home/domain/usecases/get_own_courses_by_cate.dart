import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/forget_password/domain/repository/forgot_password_repository.dart';
import 'package:education_project/features/home/domain/entities/category.dart';
import 'package:education_project/features/home/domain/entities/course.dart';
import 'package:education_project/features/home/domain/entities/user.dart';
import 'package:education_project/features/home/domain/repository/cate_repository.dart';
import 'package:education_project/features/home/domain/repository/course_repository.dart';

import '../repository/user_info_repository.dart';


class GetOwnCoursesByCateUseCase implements UseCase<List<CourseEntity>,int>{
  final CourseRepository _courseRepository;

  GetOwnCoursesByCateUseCase(this._courseRepository);

  @override
  Future<List<CourseEntity>> call({int? params}) async {
    try {
      return await _courseRepository.getOwnCoursesByCate(params!);

    } catch (e) {
      rethrow;
    }
  }


}