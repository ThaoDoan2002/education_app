
import '../../domain/entity/note.dart';

class NoteModel extends NoteEntity {
  const NoteModel({
    required int id,
    required String content,
    required int timestamp,

  }) : super(
    id: id,
    content: content,
    timestamp: timestamp,
  );

  factory NoteModel.fromJson(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] ?? 0,
      content: map['content'] ?? 0,
      timestamp: map['timestamp'] ?? "",
    );
  }
}
