import 'package:equatable/equatable.dart';
import 'course.dart';

class ListCourseEntity extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<CourseEntity> results;

  const ListCourseEntity({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  @override
  List<Object?> get props {
    return [count, next, previous, results];
  }
}
