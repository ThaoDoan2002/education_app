import 'package:equatable/equatable.dart';

class NoteEntity extends Equatable {
  final int id;
  final String content;
  final int timestamp;

  const NoteEntity({
    required this.id,
    required this.content,
    required this.timestamp,
  });

  @override
  List<Object?> get props {
    return [
      id,
      content,
      timestamp
    ];
  }
}
