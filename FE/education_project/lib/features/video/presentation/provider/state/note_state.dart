import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';


abstract class NoteState extends Equatable{
  final DioException ? error;

  const NoteState({this.error});

  @override
  List<Object?> get props => [error];
}

class NoteInit extends NoteState{
  const NoteInit();
}

class NoteLoading extends NoteState{
  const NoteLoading();
}

class NoteDone extends NoteState{
  const NoteDone();
}



class NoteError extends NoteState{
  const NoteError(DioException error) : super(error: error);
}
