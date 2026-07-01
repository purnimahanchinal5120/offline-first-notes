import '../../domain/entities/operation_type.dart';

class SyncOperationModel {
  final String noteId;

  // NEW
  final String? remoteId;

  final OperationType operation;
  final DateTime createdAt;

  const SyncOperationModel({
    required this.noteId,
    this.remoteId,
    required this.operation,
    required this.createdAt,
  });
}