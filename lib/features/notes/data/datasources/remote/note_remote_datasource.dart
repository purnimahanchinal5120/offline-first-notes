import '../../models/note_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> getNotes();

  Future<NoteModel> createNote(
      NoteModel note,
      );

  Future<void> updateNote(
      NoteModel note,
      );

  Future<void> deleteNote(
      String id,
      );
}