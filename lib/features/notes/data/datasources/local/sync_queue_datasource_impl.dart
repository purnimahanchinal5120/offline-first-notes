import '../../../../../core/database/queue_service.dart';
import '../../models/sync_operation_model.dart';
import 'sync_queue_datasource.dart';

class SyncQueueDataSourceImpl
    implements SyncQueueDataSource {
  @override
  Future<void> addOperation(
      SyncOperationModel operation,
      ) async {
    await QueueService.queueBox.put(
      operation.noteId,
      operation,
    );
  }

  @override
  Future<List<SyncOperationModel>> getOperations() async {
    return QueueService.queueBox.values.toList();
  }

  @override
  Future<void> removeOperation(
      String noteId,
      ) async {
    await QueueService.queueBox.delete(noteId);
  }

  @override
  Future<void> clearQueue() async {
    await QueueService.queueBox.clear();
  }
}