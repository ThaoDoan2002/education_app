import 'package:equatable/equatable.dart';

class TimelineEntity extends Equatable {
  final int id;
  final int time;
  final String description;

  const TimelineEntity({
    required this.id,
    required this.time,
    required this.description,
  });

  @override
  List<Object?> get props {
    return [
      id,
      time,
      description
    ];
  }
}
