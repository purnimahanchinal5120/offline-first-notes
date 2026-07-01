import 'package:hive/hive.dart';

import '../../../../../core/enums/sync_status.dart';
import '../../../domain/entities/note.dart';

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    return Note(
        id: reader.readString(),

        // NEW
        remoteId: reader.readBool()
            ? reader.readString()
            : null,

        title: reader.readString(),
        body: reader.readString(),

        createdAt: DateTime.fromMillisecondsSinceEpoch(
          reader.readInt(),
        ),

        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          reader.readInt(),
        ),

        lastSyncedAt: reader.readBool()
            ? DateTime.fromMillisecondsSinceEpoch(
          reader.readInt(),
        )
            : null,

        syncStatus: SyncStatus.values[
        reader.readInt()],

        version: reader.readInt(),

    isDeleted: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeString(obj.id);

    // NEW
    writer.writeBool(obj.remoteId != null);

    if (obj.remoteId != null) {
      writer.writeString(obj.remoteId!);
    }

    writer.writeString(obj.title);
    writer.writeString(obj.body);

    writer.writeInt(
      obj.createdAt.millisecondsSinceEpoch,
    );

    writer.writeInt(
      obj.updatedAt.millisecondsSinceEpoch,
    );

    writer.writeBool(
      obj.lastSyncedAt != null,
    );

    if (obj.lastSyncedAt != null) {
      writer.writeInt(
        obj.lastSyncedAt!.millisecondsSinceEpoch,
      );
    }

    writer.writeInt(
      obj.syncStatus.index,
    );

    writer.writeInt(
      obj.version,
    );

    writer.writeBool(
      obj.isDeleted,
    );
  }
}