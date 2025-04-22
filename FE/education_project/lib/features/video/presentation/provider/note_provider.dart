import 'package:dio/dio.dart';
import 'package:education_project/features/video/data/data_sources/note_api_service.dart';
import 'package:education_project/features/video/data/repository_impl/note_repository_impl.dart';
import 'package:education_project/features/video/domain/entity/note.dart';
import 'package:education_project/features/video/domain/usecase/get_notes_by_video.dart';
import 'package:education_project/features/video/domain/usecase/note.dart';
import 'package:education_project/features/video/presentation/provider/state/note_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../courses/presentation/provider/checkout_provider.dart';
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
}



final noteApiServiceProvider = Provider<NoteApiService>((ref) {
  final dio = ref.read(dioProvider);
  return NoteApiService(dio);
});

final noteUseCaseProvider = Provider<NoteUseCase>((ref) {
  final dio = Dio();
  final noteApiService = ref.watch(noteApiServiceProvider);

  final note = NoteRepositoryImpl(dio, noteApiService);
  return NoteUseCase(note);
});

final getNotesUseCaseProvider = Provider<GetNotesByVideoUseCase>((ref) {
  final dio = Dio();
  final noteApi = ref.watch(noteApiServiceProvider);

  final note = NoteRepositoryImpl(dio, noteApi );
  return GetNotesByVideoUseCase(note);
});


@Riverpod(keepAlive: true)
Future<List<NoteEntity>> notes(Ref ref, int id) async {
  final getNoteByVideo = ref.read(getNotesUseCaseProvider);
  return await getNoteByVideo.call(params:id);
}