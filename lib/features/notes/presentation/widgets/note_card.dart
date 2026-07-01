import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/note.dart';
import 'sync_status_chip.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(note.id),

      background: _swipeBackground(
        Alignment.centerLeft,
        AppColors.primary,
        Icons.edit_rounded,
        "Edit",
      ),

      secondaryBackground: _swipeBackground(
        Alignment.centerRight,
        AppColors.danger,
        Icons.delete_rounded,
        "Delete",
      ),

      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit();
          return false;
        }

        return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Delete Note"),
            content: const Text(
              "Are you sure you want to delete this note?",
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context, false),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.pop(context, true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
            false;
      },

      onDismissed: (_) => onDelete(),

      child: Hero(
        tag: note.id,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title.isEmpty
                              ? "Untitled"
                              : note.title,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.w700,
                            color:
                            AppColors.title,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SyncStatusChip(
                        status: note.syncStatus,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    note.body,
                    maxLines: 4,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.7,
                      color:
                      AppColors.subtitle,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 16,
                        color:
                        AppColors.subtitle,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat(
                          "dd MMM • hh:mm a",
                        ).format(
                          note.updatedAt,
                        ),
                        style:
                        const TextStyle(
                          color: AppColors.subtitle,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _swipeBackground(
      Alignment alignment,
      Color color,
      IconData icon,
      String text,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding:
      const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}