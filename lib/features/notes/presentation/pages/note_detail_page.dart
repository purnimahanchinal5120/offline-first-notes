import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/note.dart';
import '../widgets/sync_status_chip.dart';
import 'add_edit_note_page.dart';

class NoteDetailPage extends StatelessWidget {
  final Note note;

  const NoteDetailPage({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditNotePage(
                    note: note,
                  ),
                ),
              );

              if (updated == true && context.mounted) {
                Navigator.pop(context);
                return;
              }
            },
          ),
        ],
      ),
      body: Hero(
        tag: note.id,
        child: Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title.isEmpty ? "Untitled" : note.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                SyncStatusChip(
                  status: note.syncStatus,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat(
                        'dd MMM yyyy • hh:mm a',
                      ).format(note.updatedAt),
                    ),
                  ],
                ),

                const Divider(height: 40),

                SelectableText(
                  note.body,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}