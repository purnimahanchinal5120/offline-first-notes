import 'package:hive_flutter/hive_flutter.dart';

import '../../features/notes/data/datasources/local/sync_queue_adapter.dart';
import '../../features/notes/data/models/sync_operation_model.dart';

class QueueService {
  static const queueBoxName = 'sync_queue';

  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SyncQueueAdapter());
    }

    await Hive.openBox<SyncOperationModel>(queueBoxName);
  }

  static Box<SyncOperationModel> get queueBox =>
      Hive.box<SyncOperationModel>(queueBoxName);
}