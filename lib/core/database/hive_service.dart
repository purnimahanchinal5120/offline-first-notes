import 'package:hive_flutter/hive_flutter.dart';

import '../../features/notes/data/datasources/local/note_adapter.dart';
import '../../features/notes/domain/entities/note.dart';

class HiveService {
  static const String notesBoxName = 'notes';

  static Future<void> init() async {
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(NoteAdapter());
    }

    await Hive.openBox<Note>(notesBoxName);
  }

  static Box<Note> get notesBox => Hive.box<Note>(notesBoxName);
}