import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/remote/note_remote_datasource.dart';
import '../../data/datasources/remote/note_remote_datasource_impl.dart';

final noteRemoteProvider =
Provider<NoteRemoteDataSource>((ref) {
  return NoteRemoteDataSourceImpl();
});