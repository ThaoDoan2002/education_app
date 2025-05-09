import 'package:education_project/core/constants/constants.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'note_api_service.g.dart';

@RestApi(baseUrl: BASE_URL)
abstract class NoteApiService {
  factory NoteApiService(Dio dio, {String baseUrl}) = _NoteApiService;

  @POST('/notes/')
  Future<HttpResponse<dynamic>> createNote(
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/notes/{id}/')
  Future<HttpResponse<dynamic>> deleteNote(
    @Path('id') int noteID,
  );

  @GET('/videos/{id}/notes/')
  Future<HttpResponse<dynamic>> getNotesByVideo(
      @Path('id') int videoId);
}
