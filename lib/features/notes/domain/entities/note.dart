import 'package:equatable/equatable.dart';

import '../../../../core/enums/sync_status.dart';

class Note extends Equatable {
  final String id;

  /// MockAPI ID
  final String? remoteId;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final SyncStatus syncStatus;
  final int version;
  final int lastSyncedVersion;
  final bool isDeleted;

  const Note({
    required this.id,
    this.remoteId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
    this.syncStatus = SyncStatus.pending,
    this.version = 1,
    this.lastSyncedVersion = 1,
    this.isDeleted = false,
  });

  Note copyWith({
    String? id,
    String? remoteId,
    String? title,
    String? body,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSyncedAt,
    SyncStatus? syncStatus,
    int? version,
    int? lastSyncedVersion,
    bool? isDeleted,
  }) {
    return Note(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      version: version ?? this.version,
      lastSyncedVersion: lastSyncedVersion ?? this.lastSyncedVersion,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [
    id,
    remoteId,
    title,
    body,
    createdAt,
    updatedAt,
    lastSyncedAt,
    syncStatus,
    version,
    lastSyncedVersion,
    isDeleted,
  ];
}