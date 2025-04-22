
import '../../domain/entity/timeline.dart';

class TimeLineModel extends TimelineEntity {
  const TimeLineModel({
    required int id,
    required int time,
    required String description,

  }) : super(
    id: id,
    time: time,
    description: description,
  );

  factory TimeLineModel.fromJson(Map<String, dynamic> map) {
    return TimeLineModel(
      id: map['id'] ?? 0,
      time: map['time_in_seconds'] ?? 0,
      description: map['description'] ?? "",
    );
  }
}
