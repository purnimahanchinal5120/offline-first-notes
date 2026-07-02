import 'package:dio/dio.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../../models/note_model.dart';
import 'note_remote_datasource.dart';

class NoteRemoteDataSourceImpl
    implements NoteRemoteDataSource {
  final Dio dio = DioClient.dio;

  @override
  Future<List<NoteModel>> getNotes() async {
    final response = await dio.get(
      ApiConstants.notes,
    );

    return (response.data as List)
        .map(
          (e) => NoteModel.fromJson(e),
    )
        .toList();
  }

  @override
  Future<NoteModel> createNote(
      NoteModel note,
      ) async {
    final response = await dio.post(
      ApiConstants.notes,
      data: note.toJson(),
    );

    return NoteModel.fromJson(
      response.data,
    );
  }

  @override
  Future<void> updateNote(
      NoteModel note,
      ) async {
    await dio.put(
      "${ApiConstants.notes}/${note.remoteId}",
      data: note.toJson(),
    );
  }

  @override
  Future<void> deleteNote(
      String id,
      ) async {
    await dio.delete(
      "${ApiConstants.notes}/$id",
    );
  }

  @override
  Future<NoteModel> getNote(
      String remoteId,
      ) async {
    final response = await dio.get(
      "${ApiConstants.notes}/$remoteId",
    );

    return NoteModel.fromJson(
      response.data,
    );
  }
}