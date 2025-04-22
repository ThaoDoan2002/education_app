import 'package:education_project/features/video/data/models/TimeLine.dart';
import 'package:education_project/features/video/domain/entity/timeline.dart';
import 'package:education_project/features/video/domain/entity/video.dart';

class VideoModel extends VideoEntity {
  const VideoModel({
    required int id,
    required String thumbnail,
    required String url,
    required List<TimelineEntity> timelines,
  }) : super(id: id, thumbnail: thumbnail, url: url, timelines: timelines);

  factory VideoModel.fromJson(Map<String, dynamic> map) {
    return VideoModel(
      id: map['id'] ?? 0,
      thumbnail: map['thumbnail'] ?? "",
      url: map['url'] ?? "",
      timelines: (map['timelines'] as List<dynamic>?)
              ?.map((e) => TimeLineModel.fromJson(e as Map<String, dynamic>))
              .toList()
              .cast<TimelineEntity>()
          ??
          [],
    );
  }
}
