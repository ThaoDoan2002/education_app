import 'package:education_project/core/usecase/usecase.dart';
import 'package:education_project/features/video/domain/repository/note_repository.dart';





class DeleteNoteUseCase implements UseCase<void,int>{
  final NoteRepository _repository;

  DeleteNoteUseCase(this._repository);

  @override
  Future<void> call({int? params}) async {
    try {
      return await _repository.deleteNote(params!);
    } catch (e) {
      rethrow;
    }
  }


}