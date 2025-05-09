import 'package:dio/dio.dart';
import 'package:education_project/features/video/data/repository_impl/video_repository_impl.dart';
import 'package:education_project/features/video/domain/entity/video.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/injection_container.dart';
import '../../data/data_sources/video_api_service.dart';
import '../../domain/usecase/video.dart';



part 'video_provider.g.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final videoApiServiceProvider = Provider<VideoApiService>((ref) {
  return s1<VideoApiService>();
});

final getVideoUseCaseProvider = Provider<VideoUseCase>((ref) {
  return s1<VideoUseCase>();
});

@Riverpod(keepAlive: true)
Future<VideoEntity> video(Ref ref, int id) async {
  final getVideo = ref.read(getVideoUseCaseProvider);
  return await getVideo.call(params:id);
}