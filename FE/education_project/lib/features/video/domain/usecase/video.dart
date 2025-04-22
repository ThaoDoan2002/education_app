import 'package:education_project/core/usecase/usecase.dart';

import 'package:education_project/features/video/data/repository_impl/video_repository_impl.dart';
import 'package:education_project/features/video/domain/entity/video.dart';

import '../repository/video_repository.dart';




class VideoUseCase implements UseCase<VideoEntity,int>{
  final VideoRepository _repository;

  VideoUseCase(this._repository);

  @override
  Future<VideoEntity> call({int? params}) async {
    try {
      return await _repository.getVideo(params!);

    } catch (e) {
      rethrow;
    }
  }


}