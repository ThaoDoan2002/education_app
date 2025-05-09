
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:education_project/core/resources/data_state.dart';
import 'package:education_project/features/video/data/data_sources/note_api_service.dart';

import 'package:education_project/features/video/domain/entity/note.dart';

import '../../domain/repository/note_repository.dart';
import '../models/note.dart';


class NoteRepositoryImpl implements NoteRepository {

  final NoteApiService _noteApiService;


  NoteRepositoryImpl( this._noteApiService);



  @override
  Future<void> createNote(int timestamp, String content, int videoId) async{
    try {
      final httpResponse = await _noteApiService.createNote({'content': content, 'timestamp': timestamp, 'video_id': videoId});
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        print('Edit!');
      }else if (httpResponse.response.statusCode == HttpStatus.created) {
        print('created!');
      }
      else {
        throw Exception(
            'Failed to create note: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;

    }
  }

  @override
  Future<DataState<List<NoteEntity>>> getNotes(int videoID) async{
    try {
      final httpResponse = await _noteApiService.getNotesByVideo(videoID);
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<NoteEntity> notes = (httpResponse.response.data as List)
            .map((noteJson) => NoteModel.fromJson(noteJson))
            .toList();
        return DataSuccess(notes);
      } else {
        return DataFailed(DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions));
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<void> deleteNote(int noteID) async{
    try {
      final httpResponse = await _noteApiService.deleteNote(noteID);
      if (httpResponse.response.statusCode == HttpStatus.noContent) {
        print('DELETED!');
      } else {
        throw Exception(
            'Failed to delete note: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;

    }
  }
}
