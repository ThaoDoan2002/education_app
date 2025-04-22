
import 'package:education_project/features/video/domain/entity/video.dart';

abstract class VideoRepository {
  Future<VideoEntity> getVideo(int id);

}