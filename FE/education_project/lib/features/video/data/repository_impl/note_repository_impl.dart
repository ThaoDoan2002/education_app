
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:education_project/config/storage/token_storage.dart';
import 'package:education_project/features/video/data/data_sources/note_api_service.dart';

import 'package:education_project/features/video/data/data_sources/video_api_service.dart';
import 'package:education_project/features/video/data/models/video.dart';
import 'package:education_project/features/video/domain/entity/note.dart';
import 'package:education_project/features/video/domain/entity/video.dart';
import 'package:education_project/features/video/domain/repository/video_repository.dart';

import '../../domain/repository/note_repository.dart';
import '../models/note.dart';


class NoteRepositoryImpl implements NoteRepository {
  final Dio _dio;
  final NoteApiService _noteApiService;

  NoteRepositoryImpl(this._dio, this._noteApiService) {
    // Thêm interceptor để log request và response
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }



  @override
  Future<void> createNote(int timestamp, String content, int videoId) async{
    try {
      final token = await TokenStorage().getToken();
      final httpResponse = await _noteApiService.createNote('Bearer $token',{'content': content, 'timestamp': timestamp, 'video_id': videoId});
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
  Future<List<NoteEntity>> getNotes(int videoID) async{
    try {
      final token = await TokenStorage().getToken();
      final httpResponse = await _noteApiService.getNotesByVideo(videoID,'Bearer $token');
      if (httpResponse.response.statusCode == HttpStatus.ok) {
        final List<NoteEntity> notes = (httpResponse.response.data as List)
            .map((noteJson) => NoteModel.fromJson(noteJson))
            .toList();
        return notes;
      } else {
        throw Exception(
            'Failed to create note: ${httpResponse.response.statusMessage}');
      }
    } catch (e) {
      rethrow;

    }
  }
}
