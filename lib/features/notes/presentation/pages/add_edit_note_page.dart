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
    } catch (_) {}

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: false,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? "Edit Note" : "New Note",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff1F2937),
                fontSize: 22,
              ),
            ),
            Text(
              isEditing
                  ? "Update your note"
                  : "Capture your thoughts",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Title",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff374151),
                ),
              ),

              const SizedBox(height: 10),

              NoteTitleField(
                controller: titleController,
              ),

              const SizedBox(height: 24),

              const Text(
                "Content",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff374151),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: NoteBodyField(
                  controller: bodyController,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}