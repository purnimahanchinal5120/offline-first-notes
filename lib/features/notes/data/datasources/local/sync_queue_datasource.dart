import '../../models/sync_operation_model.dart';

abstract class SyncQueueDataSource {
  Future<void> addOperation(
      SyncOperationModel operation,
      );

  Future<List<SyncOperationModel>> getOperations();

  Future<void> removeOperation(String noteId);

  Future<void> clearQueue();
}