import '../../features/notes/data/datasources/local/note_local_datasource.dart';
import '../../features/notes/data/datasources/remote/note_remote_datasource.dart';
import '../../features/notes/data/models/note_model.dart';
import '../../features/notes/data/models/sync_operation_model.dart';
import '../../features/notes/domain/entities/operation_type.dart';
import '../../features/notes/domain/repositories/sync_queue_repository.dart';
import '../enums/sync_status.dart';

class ConflictResolver {
  final NoteLocalDataSource localDataSource;
  final NoteRemoteDataSource remoteDataSource;
  final SyncQueueRepository queueRepository;

  ConflictResolver({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.queueRepository,
  });

  Future<void> keepLocal(String noteId) async {
    final local = await localDataSource.getNoteById(noteId);

    if (local == null) return;

    await remoteDataSource.updateNote(NoteModel.fromEntity(local));

    await localDataSource.updateNote(
      NoteModel.fromEntity(
        local.copyWith(
          syncStatus: SyncStatus.synced,
          lastSyncedVersion: local.version,
          lastSyncedAt: DateTime.now(),
        ),
      ),
    );

    await queueRepository.removeOperation(noteId);
  }

  Future<void> keepServer(String noteId) async {
    final local = await localDataSource.getNoteById(noteId);

    if (local == null || local.remoteId == null) return;

    final remote = await remoteDataSource.getNote(local.remoteId!);

    await localDataSource.updateNote(
      NoteModel.fromEntity(
        local.copyWith(
          title: remote.title,
          body: remote.body,
          updatedAt: remote.updatedAt,
          version: remote.version,
          lastSyncedVersion: remote.version,
          lastSyncedAt: DateTime.now(),
          syncStatus: SyncStatus.synced,
        ),
      ),
    );

    await queueRepository.removeOperation(noteId);
  }

  Future<void> keepBoth(String noteId) async {
    final local = await localDataSource.getNoteById(noteId);

    if (local == null || local.remoteId == null) return;

    final remote = await remoteDataSource.getNote(local.remoteId!);

    final mergedBody = '''
===== MY CHANGES =====

${local.body}

==============================

===== SERVER VERSION =====

${remote.body}
''';

    await localDataSource.updateNote(
      NoteModel.fromEntity(
        local.copyWith(
          body: mergedBody,
          updatedAt: DateTime.now(),

          // IMPORTANT
          version: remote.version + 1,
          lastSyncedVersion: remote.version,

          syncStatus: SyncStatus.pending,
          lastSyncedAt: DateTime.now(),
        ),
      ),
    );

    // Remove old queued operation
    await queueRepository.removeOperation(noteId);

    // Queue new update
    await queueRepository.addOperation(
      SyncOperationModel(
        noteId: noteId,
        remoteId: local.remoteId,
        operation: OperationType.update,
        createdAt: DateTime.now(),
      ),
    );
  }
}
