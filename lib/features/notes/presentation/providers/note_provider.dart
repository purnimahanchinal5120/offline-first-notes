import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/enums/sync_status.dart';
import '../../../../core/sync/sync_provider.dart';
import '../../data/datasources/local/note_local_datasource.dart';
import '../../data/datasources/local/note_local_datasource_impl.dart';
import '../../data/datasources/local/sync_queue_datasource.dart';
import '../../data/datasources/local/sync_queue_datasource_impl.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../data/repositories/sync_queue_repository_impl.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/repositories/sync_queue_repository.dart';

/// --------------------
/// Local Datasource
/// --------------------

final noteLocalDataSourceProvider = Provider<NoteLocalDataSource>((ref) {
  return NoteLocalDataSourceImpl();
});

/// --------------------
/// Sync Queue Datasource
/// --------------------

final syncQueueLocalProvider = Provider<SyncQueueDataSource>((ref) {
  return SyncQueueDataSourceImpl();
});

/// --------------------
/// Sync Queue Repository
/// --------------------

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>((ref) {
  return SyncQueueRepositoryImpl(ref.read(syncQueueLocalProvider));
});

/// --------------------
/// Note Repository
/// --------------------

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepositoryImpl(
    localDataSource: ref.read(noteLocalDataSourceProvider),
    queueRepository: ref.read(syncQueueRepositoryProvider),
  );
});

/// --------------------
/// Note StateNotifier
/// --------------------

final noteProvider =
StateNotifierProvider<NoteNotifier, AsyncValue<List<Note>>>((ref) {
  return NoteNotifier(
    repository: ref.read(noteRepositoryProvider),
    ref: ref,
  )..loadNotes();
});

class NoteNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NoteRepository repository;
  final Ref ref;

  NoteNotifier({
    required this.repository,
    required this.ref,
  }) : super(const AsyncLoading());

  Future<void> loadNotes() async {
    try {
      final notes = await repository.getNotes();
      state = AsyncData(notes);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Note? getNoteById(String id) {
    final currentState = state;

    if (currentState is AsyncData<List<Note>>) {
      try {
        return currentState.value.firstWhere((note) => note.id == id);
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  Future<void> addNote(Note note) async {
    await repository.addNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await repository.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await repository.deleteNote(id);
    await loadNotes();
  }

  Future<void> clearAll() async {
    await repository.clearAll();
    await loadNotes();
  }

  Future<void> saveNote({
    Note? existingNote,
    required String title,
    required String body,
  }) async {
    if (title.trim().isEmpty && body.trim().isEmpty) {
      return;
    }

    if (existingNote == null) {
      final note = Note(
        id: const Uuid().v4(),
        title: title.trim(),
        body: body.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),

        syncStatus: SyncStatus.pending,

        version: 1,
      );
      await addNote(note);
    } else {
      await updateNote(
        existingNote.copyWith(
          title: title.trim(),
          body: body.trim(),
          updatedAt: DateTime.now(),

          // NEW
          syncStatus: SyncStatus.pending,

          // keep the previous sync time until a successful sync
          lastSyncedAt: existingNote.lastSyncedAt,

          version: existingNote.version + 1,
        ),
      );
    }
  }
}
