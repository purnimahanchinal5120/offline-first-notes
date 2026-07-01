import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/hive_service.dart';
import 'core/database/queue_service.dart';
import 'core/sync/sync_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/notes/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  await QueueService.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Starts listening for connectivity changes
    ref.read(connectivityListenerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline Notes',
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}