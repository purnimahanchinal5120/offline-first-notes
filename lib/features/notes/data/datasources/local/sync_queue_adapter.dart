import 'package:hive/hive.dart';

import '../../models/sync_operation_model.dart';
import '../../../domain/entities/operation_type.dart';

class SyncQueueAdapter extends TypeAdapter<SyncOperationModel> {
  @override
  final int typeId = 1;

  @override
  SyncOperationModel read(BinaryReader reader) {
    return SyncOperationModel(
      noteId: reader.readString(),

      // NEW
      remoteId: reader.read(),

      operation: OperationType.values[reader.readInt()],

      createdAt: DateTime.fromMillisecondsSinceEpoch(
        reader.readInt(),
      ),
    );
  }

  @override
  void write(
      BinaryWriter writer,
      SyncOperationModel obj,
      ) {
    writer.writeString(obj.noteId);

    // NEW
    writer.write(obj.remoteId);

    writer.writeInt(obj.operation.index);

    writer.writeInt(
      obj.createdAt.millisecondsSinceEpoch,
    );
  }
}