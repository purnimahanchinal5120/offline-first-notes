import 'package:flutter/foundation.dart';

import '../../features/notes/data/datasources/local/note_local_datasource.dart';
import '../../features/notes/data/datasources/remote/note_remote_datasource.dart';
import '../../features/notes/data/models/note_model.dart';
import '../../features/notes/data/models/sync_operation_model.dart';
import '../../features/notes/domain/entities/operation_type.dart';
import '../../features/notes/domain/repositories/sync_queue_repository.dart';
import '../enums/sync_status.dart';

class SyncManager {
  final NoteLocalDataSource localDataSource;
  final NoteRemoteDataSource remoteDataSource;
  final SyncQueueRepository queueRepository;

  bool _isSyncing = false;

  SyncManager({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.queueRepository,
  });

  Future<void> sync() async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      debugPrint("========== SYNC START ==========");

      // STEP 1
      // Download latest first and detect conflicts
      await _downloadLatestNotes();

      // STEP 2
      // Process queue
      final operations = await queueRepository.getOperations();
      debugPrint("QUEUE SIZE = ${operations.length}");
      operations.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      for (final operation in operations) {
        try {
          final note = await localDataSource.getNoteById(operation.noteId);

          // Skip conflicted notes
          if (note != null && note.syncStatus == SyncStatus.conflict) {
            debugPrint("Skipping conflicted note ${note.id}");
            continue;
          }

          debugPrint("Queue -> ${operation.operation}  ${operation.noteId}");

          switch (operation.operation) {
            case OperationType.create:
              await _create(operation.noteId);
              break;

            case OperationType.update:
              await _update(operation.noteId);
              break;

            case OperationType.delete:
              await _delete(operation);
              break;
          }

          await queueRepository.removeOperation(operation.noteId);
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      // STEP 3
      // Download again so local matches server
      await _downloadLatestNotes();

      debugPrint("========== SYNC END ==========");
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _create(String noteId) async {
    final local = await localDataSource.getNoteById(noteId);

    if (local == null) return;

    final remote = await remoteDataSource.createNote(local);

    await localDataSource.updateNote(
      NoteModel.fromEntity(
        local.copyWith(
          remoteId: remote.remoteId,
          lastSyncedAt: DateTime.now(),
          syncStatus: SyncStatus.synced,
          lastSyncedVersion: remote.version,
        ),
      ),
    );

    debugPrint("CREATED -> localId=${local.id}, remoteId=${remote.remoteId}");
  }

  Future<void> _update(String noteId) async {
    final local = await localDataSource.getNoteById(noteId);

    if (local == null) return;

    if (local.remoteId == null) {
      await _create(noteId);
      return;
    }

    await remoteDataSource.updateNote(local);

    await localDataSource.updateNote(
      NoteModel.fromEntity(
        local.copyWith(
          lastSyncedAt: DateTime.now(),
          syncStatus: SyncStatus.synced,
          lastSyncedVersion: local.version,
        ),
      ),
    );
  }

  Future<void> _delete(SyncOperationModel operation) async {
    if (operation.remoteId != null) {
      debugPrint("Calling MockAPI DELETE...");
      debugPrint("DELETE OPERATION");
      debugPrint("noteId = ${operation.noteId}");
      debugPrint("remoteId = ${operation.remoteId}");
      await remoteDataSource.deleteNote(operation.remoteId!);
      debugPrint("MockAPI DELETE SUCCESS");
    }

    final local = await localDataSource.getNoteById(operation.noteId);

    if (local != null) {
      await localDataSource.deleteNote(operation.noteId);
    }
    debugPrint("DELETE OPERATION");
    debugPrint("remoteId = ${operation.remoteId}");
    debugPrint("noteId = ${operation.noteId}");
  }

  Future<void> _downloadLatestNotes() async {
    final remoteNotes = await remoteDataSource.getNotes();
    final localNotes = await localDataSource.getNotes();

    debugPrint("REMOTE COUNT: ${remoteNotes.length}");
    debugPrint("LOCAL COUNT: ${localNotes.length}");

    for (final local in localNotes) {
      debugPrint(
        "LOCAL -> id=${local.id}, remoteId=${local.remoteId}, title=${local.title}",
      );
    }

    for (final remote in remoteNotes) {
      debugPrint(
        "REMOTE -> remoteId=${remote.remoteId}, title=${remote.title}",
      );
    }

    // -------------------------
    // Add / Update
    // -------------------------
    debugPrint("BEFORE ADD/UPDATE LOOP");
    for (final remote in remoteNotes) {
      debugPrint(">>>>>>>> ENTERED REMOTE LOOP <<<<<<<<");
      final local = await localDataSource.getNoteByRemoteId(remote.remoteId!);

      debugPrint(
          "LOCAL VERSION=${local?.version} "
              "LAST_SYNC=${local?.lastSyncedVersion}");

      debugPrint(
          "REMOTE VERSION=${remote.version}");

      if (local == null) {
        await localDataSource.addNote(remote);
        continue;
      }

      final baseVersion = local.lastSyncedVersion;

      final localChanged = local.version > baseVersion;
      final remoteChanged = remote.version > baseVersion;

      debugPrint(
          "localChanged=$localChanged "
              "remoteChanged=$remoteChanged");

      debugPrint(
          "LOCAL v=${local.version}, "
              "REMOTE v=${remote.version}, "
              "BASE=$baseVersion");

      debugPrint(
          "localChanged=$localChanged "
              "remoteChanged=$remoteChanged");

      if (localChanged && remoteChanged) {
        debugPrint("CONFLICT DETECTED -> ${local.id}");

        await localDataSource.updateNote(
          NoteModel.fromEntity(local.copyWith(syncStatus: SyncStatus.conflict)),
        );

        continue;
      }

      if (remote.updatedAt.isAfter(local.updatedAt)) {
        await localDataSource.updateNote(
          NoteModel(
            id: local.id,
            remoteId: remote.remoteId,
            title: remote.title,
            body: remote.body,
            createdAt: remote.createdAt,
            updatedAt: remote.updatedAt,
            lastSyncedAt: DateTime.now(),
            syncStatus: SyncStatus.synced,
            version: remote.version,
            lastSyncedVersion: remote.version,
            isDeleted: remote.isDeleted,
          ),
        );
      }
    }

    // -------------------------
    // Delete local notes
    // which no longer exist remotely
    // -------------------------

    for (final local in localNotes) {
      if (local.remoteId == null) continue;

      final exists = remoteNotes.any(
        (remote) => remote.remoteId == local.remoteId,
      );

      if (!exists) {
        await localDataSource.deleteNote(local.id);
      }
    }
  }
}
