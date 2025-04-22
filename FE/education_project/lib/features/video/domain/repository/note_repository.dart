

import 'package:education_project/features/video/domain/entity/note.dart';

abstract class NoteRepository {
  Future<void> createNote(int timestamp, String content, int videoID);
  Future<List<NoteEntity>> getNotes(int videoID);

}