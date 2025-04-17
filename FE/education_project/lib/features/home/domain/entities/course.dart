import 'package:equatable/equatable.dart';

class CourseEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String thumbnail;
  final int price;

  const CourseEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
    required this.price,
  });

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      thumbnail,
      price
    ];
  }
}
