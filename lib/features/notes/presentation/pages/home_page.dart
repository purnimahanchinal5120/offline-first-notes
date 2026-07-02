import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enums/sync_status.dart';
import '../../../../core/network/connectivity_provider.dart';
import '../../../../core/sync/sync_provider.dart' as sync;
import '../providers/note_provider.dart';
import '../widgets/connectivity_banner.dart';
import '../widgets/empty_notes_widget.dart';
import '../widgets/home_header.dart';
import '../widgets/note_list.dart';
import '../widgets/search_bar_widget.dart';
import 'add_edit_note_page.dart';
import 'conflict_resolution_page.dart';
import 'note_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController searchController = TextEditingController();

  String search = "";

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(noteProvider);
    final connectivity = ref.watch(connectivityProvider);
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: false,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Offline Notes",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xff1F2937),
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Offline-first synchronization",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        elevation: 5,
        backgroundColor: const Color(0xff4F46E5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          "New Note",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditNotePage(),
            ),
          );
        },
      ),

      body: notesState.when(
        loading: () =>
        const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(
          child: Text(e.toString()),
        ),

        data: (notes) {
          final filtered = notes.where((note) {
            return note.title.toLowerCase().contains(search) ||
                note.body.toLowerCase().contains(search);
          }).toList();

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(sync.manualSyncProvider)();
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                0,
              ),
              child: Column(
                children: [
                  connectivity.when(
                    data: (online) => ConnectivityBanner(
                      online: online,
                    ),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),

                  const SizedBox(height: 16),
                  HomeHeader(
                    totalNotes: notes.length,
                  ),

                  const SizedBox(height: 20),

                  SearchBarWidget(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        search = value.toLowerCase();
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: filtered.isEmpty
                        ? const EmptyNotesWidget()
                        : NoteList(
                      notes: filtered,
                      onTap: (note) {
                        if (note.syncStatus == SyncStatus.conflict) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ConflictResolutionPage(
                                localNote: note,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  NoteDetailPage(note: note),
                            ),
                          );
                        }
                      },
                      onEdit: (note) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AddEditNotePage(note: note),
                          ),
                        );
                      },
                      onDelete: (note) async {
                        debugPrint("HOME DELETE START");

                        try {
                          await ref
                              .read(noteProvider.notifier)
                              .deleteNote(note.id);

                          debugPrint("DELETE FINISHED");
                        } catch (e, s) {
                          debugPrint("DELETE ERROR: $e");
                          debugPrint(s.toString());
                        }

                        debugPrint("CALLING MANUAL SYNC");

                        try {
                          await ref.read(sync.manualSyncProvider)();
                        } catch (e) {
                          debugPrint("SYNC ERROR: $e");
                        }

                        debugPrint("HOME DELETE END");
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}