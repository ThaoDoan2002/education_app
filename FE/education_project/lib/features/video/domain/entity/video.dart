import 'package:education_project/features/video/domain/entity/timeline.dart';
import 'package:equatable/equatable.dart';

class VideoEntity extends Equatable {
  final int id;
  final String thumbnail;
  final String url;
  final List<TimelineEntity> timelines;

  const VideoEntity({
    required this.timelines,
    required this.id,
    required this.thumbnail,
    required this.url,
  });

  @override
  List<Object?> get props {
    return [id, thumbnail, url, timelines];
  }
}
