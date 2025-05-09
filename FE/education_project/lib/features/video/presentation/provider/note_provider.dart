import 'package:dio/dio.dart';
import 'package:education_project/features/video/data/data_sources/note_api_service.dart';
import 'package:education_project/features/video/data/models/note.dart';
import 'package:education_project/features/video/domain/entity/note.dart';
import 'package:education_project/features/video/domain/usecase/delete_note.dart';
import 'package:education_project/features/video/domain/usecase/get_notes_by_video.dart';
import 'package:education_project/features/video/domain/usecase/note.dart';
import 'package:education_project/features/video/presentation/provider/state/note_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/resources/data_state.dart';
import '../../../../core/utils/injection_container.dart';
import '../../domain/usecase/params/note_params.dart';

part 'note_provider.g.dart';

@Riverpod(keepAlive: true)
class NoteNotifier extends _$NoteNotifier {
  @override
  NoteState build() {
    return const NoteInit();
  }

  // Phương thức xử lý đăng nhập
  Future<void> createNote(NoteBodyParams params) async {
    // Đặt trạng thái loading
    state = const NoteLoading();

    try {
      await ref.read(noteUseCaseProvider).call(params: params);
      ref.invalidate(notesProvider(params.videoID));

    } catch (e) {
      print(e);
      if (e is DioException) {

        state = NoteError(e);
      } else {
        state = NoteError(DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Unknown error occurred'));
      }
    }
  }

  // Phương thức xử lý đăng nhập
  Future<void> deleteNote(int videoID, int notId) async {
    print('--------');
    print(notId);
    // Đặt trạng thái loading
    state = const NoteLoading();

    try {
      await ref.read(deleteNoteUseCaseProvider).call(params: notId);
      ref.invalidate(notesProvider(videoID));

    } catch (e) {
      print(e);
      if (e is DioException) {

        state = NoteError(e);
      } else {
        state = NoteError(DioException(
            requestOptions: RequestOptions(path: ''),
            error: 'Unknown error occurred'));
      }
    }
  }
}



final noteApiServiceProvider = Provider<NoteApiService>((ref) {
  return s1<NoteApiService>();
});

final noteUseCaseProvider = Provider<NoteUseCase>((ref) {
  return s1<NoteUseCase>();
});

final deleteNoteUseCaseProvider = Provider<DeleteNoteUseCase>((ref) {
  return s1<DeleteNoteUseCase>();
});


final getNotesUseCaseProvider = Provider<GetNotesByVideoUseCase>((ref) {
  return s1<GetNotesByVideoUseCase>();
});


@Riverpod(keepAlive: true)
Future<List<NoteEntity>?> notes(Ref ref, int id) async {
  final getNoteByVideo = ref.read(getNotesUseCaseProvider);
  final result =  await getNoteByVideo.call(params:id);
  if (result is DataSuccess) {
    return result.data;
  } else {
    throw Exception('Failed to get Note');
  }
}