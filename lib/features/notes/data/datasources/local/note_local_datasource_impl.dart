import '../../../../../core/database/hive_service.dart';
import '../../models/note_model.dart';
import 'note_local_datasource.dart';

class NoteLocalDataSourceImpl implements NoteLocalDataSource {

  @override
  Future<void> addNote(NoteModel note) async {
    try {
      await HiveService.notesBox.put(note.id, note);
    } catch (e) {
      throw Exception('Failed to save note: $e');
    }
  }

  @override
  Future<List<NoteModel>> getNotes() async {
    final notes = HiveService.notesBox.values
        .map((e) => NoteModel.fromEntity(e))
        .toList();

    notes.sort(
          (a, b) => b.updatedAt.compareTo(a.updatedAt),
    );

    return notes;
  }

  @override
  Future<NoteModel?> getNoteByRemoteId(String remoteId) async {
    try {
      for (final note in HiveService.notesBox.values) {
        if (note.remoteId == remoteId) {
          return NoteModel.fromEntity(note);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get note by remoteId: $e');
    }
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    try {
      await HiveService.notesBox.put(note.id, note);
    } catch (e) {
      throw Exception('Failed to save note: $e');
    }
  }

  @override
  Future<NoteModel?> getNoteById(String id) async {
    final note = HiveService.notesBox.get(id);

    if (note == null) {
      return null;
    }

    return NoteModel.fromEntity(note);
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await HiveService.notesBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await HiveService.notesBox.clear();
    } catch (e) {
      throw Exception('Failed to clearall note: $e');
    }
  }
}