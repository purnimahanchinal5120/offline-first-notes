import '../../../../core/enums/sync_status.dart';
import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.title,
    required super.body,
    required super.createdAt,
    required super.updatedAt,
    super.lastSyncedAt,
    super.syncStatus,
    super.version,
    super.isDeleted,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      syncStatus: SyncStatus.values[
      (json['syncStatus'] as int)
          .clamp(0, SyncStatus.values.length - 1)],
      version: json['version'] as int,
      isDeleted: json['isDeleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      title: note.title,
      body: note.body,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      lastSyncedAt: note.lastSyncedAt,
      syncStatus: note.syncStatus,
      version: note.version,
      isDeleted: note.isDeleted,
    );
  }

  Note toEntity() {
    return Note(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastSyncedAt: lastSyncedAt,
      syncStatus: syncStatus,
      version: version,
      isDeleted: isDeleted,
    );
  }
}