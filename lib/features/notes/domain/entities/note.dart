import 'package:equatable/equatable.dart';

import '../../../../core/enums/sync_status.dart';

class Note extends Equatable {

  final String id;
  final String title;
  final String body;

  final DateTime createdAt;
  final DateTime updatedAt;

  final DateTime? lastSyncedAt;

  final SyncStatus syncStatus;

  final int version;

  final bool isDeleted;

  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.syncStatus = SyncStatus.pending,
    this.version = 1,
    this.isDeleted = false,
  });

  Note copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    SyncStatus? syncStatus,
    int? version,
    bool? isDeleted,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    title,
    body,
    createdAt,
    updatedAt,
    lastSyncedAt,
    syncStatus,
    version,
    isDeleted,
  ];

}