  import '../../../../core/enums/sync_status.dart';
  import '../../domain/entities/note.dart';

  class NoteModel extends Note {
    const NoteModel({
      required super.id,
      super.remoteId,
      required super.title,
      required super.body,
      required super.createdAt,
      required super.updatedAt,
      super.lastSyncedAt,
      super.syncStatus,
      super.version,
      super.lastSyncedVersion,
      super.isDeleted,
    });

    factory NoteModel.fromJson(Map<String, dynamic> json) {
      return NoteModel(
        id: json['id'].toString(),

        // remoteId is same as server id
        remoteId: json['id']?.toString(),

        title: json['title'] ?? '',
        body: json['body'] ?? '',

        createdAt:
            DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
            DateTime.now(),

        updatedAt:
            DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
            DateTime.now(),

        lastSyncedAt: DateTime.tryParse(json['lastSyncedAt']?.toString() ?? ''),

        syncStatus:
            SyncStatus.values[((json['syncStatus'] ?? 0) as num)
                .clamp(0, SyncStatus.values.length - 1)
                .toInt()],

        version: (json['version'] ?? 1) as int,
        lastSyncedVersion:
            (json['lastSyncedVersion'] ?? json['version'] ?? 1) as int,
        isDeleted: json['isDeleted'] ?? false,
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'title': title,
        'body': body,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'lastSyncedAt': lastSyncedAt?.toIso8601String(),
        'syncStatus': syncStatus.index,
        'version': version,
        'isDeleted': isDeleted,
      };
    }

    factory NoteModel.fromEntity(Note note) {
      return NoteModel(
        id: note.id,
        remoteId: note.remoteId,
        title: note.title,
        body: note.body,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        lastSyncedAt: note.lastSyncedAt,
        syncStatus: note.syncStatus,
        version: note.version,
        lastSyncedVersion: note.lastSyncedVersion,
        isDeleted: note.isDeleted,
      );
    }

    Note toEntity() {
      return Note(
        id: id,
        remoteId: remoteId,
        title: title,
        body: body,
        createdAt: createdAt,
        updatedAt: updatedAt,
        lastSyncedAt: lastSyncedAt,
        syncStatus: syncStatus,
        version: version,
        lastSyncedVersion: lastSyncedVersion,
        isDeleted: isDeleted,
      );
    }
  }
