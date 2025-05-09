
import 'dart:async';
import 'dart:io';


import 'package:education_project/features/video/data/data_sources/video_api_service.dart';
import 'package:education_project/features/video/data/models/video.dart';
import 'package:education_project/features/video/domain/entity/video.dart';
import 'package:education_project/features/video/domain/repository/video_repository.dart';


class VideoRepositoryImpl implements VideoRepository {

  final VideoApiService _videoApiService;


  VideoRepositoryImpl(this._videoApiService);

  @override
  Future<VideoEntity> getVideo(int id) async{
    try {
      final httpResponse = await _videoApiService.getVideo(id);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final VideoEntity video = VideoModel.fromJson(httpResponse.response.data);
        return video;
      } else {
        throw Exception(
            'Failed to get courses: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;

    }
  }
}
