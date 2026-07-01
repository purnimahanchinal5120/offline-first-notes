import '../../domain/repositories/sync_queue_repository.dart';
import '../datasources/local/sync_queue_datasource.dart';
import '../models/sync_operation_model.dart';

class SyncQueueRepositoryImpl
    implements SyncQueueRepository {
  final SyncQueueDataSource local;

  SyncQueueRepositoryImpl(this.local);

  @override
  Future<void> addOperation(
      SyncOperationModel operation,
      ) {
    return local.addOperation(operation);
  }

  @override
  Future<List<SyncOperationModel>> getOperations() {
    return local.getOperations();
  }

  @override
  Future<void> removeOperation(
      String noteId,
      ) {
    return local.removeOperation(noteId);
  }

  @override
  Future<void> clearQueue() {
    return local.clearQueue();
  }
}