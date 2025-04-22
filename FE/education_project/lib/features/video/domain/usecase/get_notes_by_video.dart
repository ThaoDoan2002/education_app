import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/video/domain/entity/note.dart';

import 'package:education_project/features/video/domain/entity/video.dart';
import 'package:education_project/features/video/domain/repository/note_repository.dart';
import 'package:education_project/features/video/domain/usecase/params/note_params.dart';
import 'package:education_project/features/video/presentation/provider/state/note_state.dart';

import '../repository/video_repository.dart';




class GetNotesByVideoUseCase implements UseCase<List<NoteEntity>,int>{
  final NoteRepository _repository;

  GetNotesByVideoUseCase(this._repository);

  @override
  Future<List<NoteEntity>> call({int? params}) async {
    try {
      return await _repository.getNotes(params!);
    } catch (e) {
      rethrow;
    }
  }


}