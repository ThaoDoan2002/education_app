

import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/features/video/domain/entity/note.dart';

abstract class NoteRepository {
  Future<void> createNote(int timestamp, String content, int videoID);
  Future<DataState<List<NoteEntity>>> getNotes(int videoID);

  Future<void> deleteNote(int noteID);

}