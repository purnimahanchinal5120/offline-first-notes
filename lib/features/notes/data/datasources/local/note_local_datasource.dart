import '../../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();

  Future<NoteModel?> getNoteById(String id);

  /// NEW
  Future<NoteModel?> getNoteByRemoteId(String remoteId);

  Future<void> addNote(NoteModel note);

  Future<void> updateNote(NoteModel note);

  Future<void> deleteNote(String id);

  Future<void> clearAll();
}