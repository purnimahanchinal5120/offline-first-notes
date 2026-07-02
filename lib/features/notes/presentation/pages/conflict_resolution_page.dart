import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/sync/sync_provider.dart';
import '../../domain/entities/note.dart';
import '../providers/note_provider.dart';
import '../providers/remote_provider.dart';

class ConflictResolutionPage extends ConsumerWidget {
  final Note localNote;

  const ConflictResolutionPage({
    super.key,
    required this.localNote,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteNoteAsync =
    ref.watch(
      remoteNoteProvider(
        localNote.remoteId!,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Resolve Conflict"),
      ),
      body: SafeArea(
        child: Column(
          children: [

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.orange,
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "This note was modified on both your device and the server.",
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: remoteNoteAsync.when(
                loading: () =>
                const Center(
                  child: CircularProgressIndicator(),
                ),

                error: (e, _) =>
                    Center(
                      child: Text(
                        e.toString(),
                      ),
                    ),

                data: (remoteNote) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      children: [

                        _NoteCard(
                          title: "My Changes",
                          note: localNote,
                        ),

                        const SizedBox(height: 20),

                        _NoteCard(
                          title: "Server Version",
                          note: remoteNote,
                        ),

                      ],
                    ),
                  );
                },
              ),
            ),

            SafeArea(
              top: false,
              minimum: const EdgeInsets.all(16),
              child: Column(
                children: [

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        await ref
                            .read(conflictResolverProvider)
                            .keepLocal(localNote.id);

                        await ref
                            .read(noteProvider.notifier)
                            .loadNotes();

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Keep My Changes",
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        await ref
                            .read(conflictResolverProvider)
                            .keepServer(localNote.id);

                        await ref
                            .read(noteProvider.notifier)
                            .loadNotes();

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Keep Server Version",
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        await ref
                            .read(conflictResolverProvider)
                            .keepBoth(localNote.id);

                        await ref.read(manualSyncProvider)();

                        await ref.read(noteProvider.notifier).loadNotes();

                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "Keep Both",
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final String title;
  final Note note;

  const _NoteCard({
    required this.title,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Version : ${note.version}",
            ),

            const SizedBox(height: 8),

            Text(
              note.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            Text(note.body),
          ],
        ),
      ),
    );
  }
}