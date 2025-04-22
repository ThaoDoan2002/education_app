import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final int id;
  final String title;
  final String description;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props {
    return [
      id,
      title,
      description
    ];
  }
}
