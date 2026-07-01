import 'package:flutter/material.dart';

import '../../domain/entities/note.dart';
import 'note_card.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final Function(Note) onTap;
  final Function(Note) onEdit;
  final Function(Note) onDelete;

  const NoteList({
    super.key,
    required this.notes,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: notes.length,
      itemBuilder: (_, index) {
        final note = notes[index];

        return NoteCard(
          note: note,
          onTap: () => onTap(note),
          onEdit: () => onEdit(note),
          onDelete: () => onDelete(note),
        );
      },
    );
  }
}