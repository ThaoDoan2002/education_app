

import 'package:education_project/core/resources/data_state.dart';

abstract class CheckoutRepository {
  Future<DataState<String>> checkoutCourse(int courseId);
}