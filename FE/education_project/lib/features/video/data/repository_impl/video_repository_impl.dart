
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';

import 'package:education_project/features/lesson/data/models/lesson.dart';
import 'package:education_project/features/lesson/domain/entities/lesson.dart';
import 'package:education_project/features/video/data/data_sources/video_api_service.dart';
import 'package:education_project/features/video/data/models/video.dart';
import 'package:education_project/features/video/domain/entity/video.dart';
import 'package:education_project/features/video/domain/repository/video_repository.dart';


class VideoRepositoryImpl implements VideoRepository {
  final Dio _dio;
  final VideoApiService _videoApiService;

  VideoRepositoryImpl(this._dio, this._videoApiService) {
    // Thêm interceptor để log request và response
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }


  @override
  Future<VideoEntity> getVideo(int id) async{
    try {
      final token = await TokenStorage().getToken();
      final httpResponse = await _videoApiService.getVideo(id,'Bearer $token');
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
