import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/video/domain/entity/note.dart';

import 'package:education_project/features/video/domain/repository/note_repository.dart';





class GetNotesByVideoUseCase implements UseCase<DataState<List<NoteEntity>>,int>{
  final NoteRepository _repository;

  GetNotesByVideoUseCase(this._repository);

  @override
  Future<DataState<List<NoteEntity>>> call({int? params}) async {
    try {
      return await _repository.getNotes(params!);
    } catch (e) {
      rethrow;
    }
  }


}