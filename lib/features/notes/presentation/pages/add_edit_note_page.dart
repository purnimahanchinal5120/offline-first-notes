import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sync/sync_provider.dart';
import '../../domain/entities/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_body_field.dart';
import '../widgets/note_title_field.dart';
import '../widgets/save_note_button.dart';

class AddEditNotePage extends ConsumerStatefulWidget {
  final Note? note;

  const AddEditNotePage({
    super.key,
    this.note,
  });

  @override
  ConsumerState<AddEditNotePage> createState() =>
      _AddEditNotePageState();
}

class _AddEditNotePageState
    extends ConsumerState<AddEditNotePage> {
  late final TextEditingController titleController;
  late final TextEditingController bodyController;

  bool get isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.note?.title ?? '',
    );

    bodyController = TextEditingController(
      text: widget.note?.body ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = titleController.text.trim();
    final body = bodyController.text.trim();

    if (title.isEmpty && body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a title or note.',
          ),
        ),
      );
      return;
    }

    await ref.read(noteProvider.notifier).saveNote(
      existingNote: widget.note,
      title: title,
      body: body,
    );
    try {
      await ref.read(manualSyncProvider)();
    } catch (_) {
      // Ignore sync failures while offline.
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? 'Edit Note'
              : 'New Note',
        ),
        actions: [
          Padding(
            padding:
            const EdgeInsets.only(right: 12),
            child: SaveNoteButton(
              onPressed: _save,
              isEditing: isEditing,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              NoteTitleField(
                controller: titleController,
              ),

              const SizedBox(height: 12),

              const Divider(),

              const SizedBox(height: 12),

              NoteBodyField(
                controller: bodyController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}