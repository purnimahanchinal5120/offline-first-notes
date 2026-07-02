import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/note_remote_datasource.dart';
import '../../data/datasources/remote/note_remote_datasource_impl.dart';
import '../../data/models/note_model.dart';

final noteRemoteProvider =
Provider<NoteRemoteDataSource>((ref) {
  return NoteRemoteDataSourceImpl();
});

final remoteNoteProvider =
FutureProvider.family<NoteModel, String>((ref, remoteId) async {
  return ref.read(noteRemoteProvider).getNote(remoteId);
});