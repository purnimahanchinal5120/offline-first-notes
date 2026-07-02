import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/notes/presentation/providers/note_provider.dart';
import '../../features/notes/presentation/providers/remote_provider.dart';
import 'conflict_resolver.dart';
import 'sync_manager.dart';

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final syncManagerProvider = Provider<SyncManager>((ref) {
  return SyncManager(
    localDataSource: ref.read(noteLocalDataSourceProvider),
    remoteDataSource: ref.read(noteRemoteProvider),
    queueRepository: ref.read(syncQueueRepositoryProvider),
  );
});

/// NEW
final manualSyncProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    debugPrint("MANUAL SYNC CALLED");
    await ref.read(syncManagerProvider).sync();
    await ref.read(noteProvider.notifier).loadNotes();
  };
});

final conflictResolverProvider = Provider<ConflictResolver>((ref) {
  return ConflictResolver(
    localDataSource: ref.read(noteLocalDataSourceProvider),
    remoteDataSource: ref.read(noteRemoteProvider),
    queueRepository: ref.read(syncQueueRepositoryProvider),
  );
});

final connectivityListenerProvider = Provider<void>((ref) {
  final connectivity = ref.read(connectivityProvider);

  connectivity.onConnectivityChanged.listen((result) async {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet)) {

      debugPrint("Internet restored. Syncing...");

      // Give the connection a moment to become usable
      await Future.delayed(const Duration(seconds: 1));

      await ref.read(manualSyncProvider)();

      debugPrint("Automatic sync completed.");
    }
  });
});