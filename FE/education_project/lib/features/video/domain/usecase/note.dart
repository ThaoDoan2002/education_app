import 'package:education_project/core/usecase/usecase.dart';

import 'package:education_project/features/video/domain/entity/video.dart';
import 'package:education_project/features/video/domain/repository/note_repository.dart';
import 'package:education_project/features/video/domain/usecase/params/note_params.dart';

import '../repository/video_repository.dart';




class NoteUseCase implements UseCase<void,NoteBodyParams>{
  final NoteRepository _repository;

  NoteUseCase(this._repository);

  @override
  Future<void> call({NoteBodyParams? params}) async {
    try {
      await _repository.createNote(params!.timestamp, params!.content, params!.videoID,);

    } catch (e) {
      rethrow;
    }
  }


}