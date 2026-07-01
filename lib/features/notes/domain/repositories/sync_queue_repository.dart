import '../../data/models/sync_operation_model.dart';

abstract class SyncQueueRepository {
  Future<void> addOperation(
      SyncOperationModel operation,
      );

  Future<List<SyncOperationModel>> getOperations();

  Future<void> removeOperation(
      String noteId,
      );

  Future<void> clearQueue();
}