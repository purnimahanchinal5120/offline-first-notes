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
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text(
              "Resolve Conflict",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff1F2937),
                fontSize: 22,
              ),
            ),

            Text(
              "Choose which version to keep",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [

            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xffFFF8E6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.orange.shade300,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Conflict Detected",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "This note was edited both locally and on the server. Select the version you want to keep.",
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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
                    child: FilledButton.icon(
                      icon: const Icon(Icons.phone_android),
                      label: const Text("Keep My Changes"),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xff4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
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
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.cloud_done),
                      label: const Text("Keep Server Version"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(
                          color: Color(0xff4F46E5),
                        ),
                        foregroundColor: const Color(0xff4F46E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
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
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      icon: const Icon(Icons.merge),
                      label: const Text("Merge Both Versions"),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: title == "My Changes"
                        ? const Color(0xffEEF2FF)
                        : const Color(0xffECFDF5),
                    borderRadius:
                    BorderRadius.circular(30),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: title == "My Changes"
                          ? const Color(0xff4F46E5)
                          : Colors.green.shade700,
                    ),
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child: Text(
                    "v${note.version}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              note.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff1F2937),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              note.body,
              style: const TextStyle(
                fontSize: 15,
                height: 1.7,
                color: Color(0xff4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }
}