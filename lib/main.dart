import 'package:flutter/material.dart';

import 'core/database/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Notes',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text("Hive Initialized"),
        ),
      ),
    );
  }
}