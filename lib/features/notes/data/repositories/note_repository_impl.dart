import '../../../../core/enums/sync_status.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/operation_type.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/sync_queue_repository.dart';
import '../datasources/local/note_local_datasource.dart';
import '../models/note_model.dart';
import '../models/sync_operation_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  final SyncQueueRepository queueRepository;

  NoteRepositoryImpl({
    required this.localDataSource,
    required this.queueRepository,
  });

  @override
  Future<void> addNote(Note note) async {
    await localDataSource.addNote(
      NoteModel.fromEntity(note),
    );

    await queueRepository.addOperation(
      SyncOperationModel(
        noteId: note.id,
        operation: OperationType.create,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> updateNote(Note note) async {
    await localDataSource.updateNote(
      NoteModel.fromEntity(note),
    );

    await queueRepository.addOperation(
      SyncOperationModel(
        noteId: note.id,
        operation: OperationType.update,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<List<Note>> getNotes() async {
    return await localDataSource.getNotes();
  }

  @override
  @override
  Future<void> deleteNote(String id) async {
    final note = await localDataSource.getNoteById(id);

    if (note == null) return;

    await queueRepository.addOperation(
      SyncOperationModel(
        noteId: note.id,
        remoteId: note.remoteId, // NEW
        operation: OperationType.delete,
        createdAt: DateTime.now(),
      ),
    );

    await localDataSource.deleteNote(id);
  }

  @override
  Future<void> clearAll() async {
    await localDataSource.clearAll();
  }
}