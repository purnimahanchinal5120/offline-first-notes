import 'package:flutter/material.dart';

class SaveNoteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEditing;

  const SaveNoteButton({
    super.key,
    required this.onPressed,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xff4F46E5),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      icon: Icon(
        isEditing
            ? Icons.edit_rounded
            : Icons.save_rounded,
      ),
      label: Text(
        isEditing ? "Update" : "Save",
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}