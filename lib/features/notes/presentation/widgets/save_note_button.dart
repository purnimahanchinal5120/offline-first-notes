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
      icon: Icon(isEditing ? Icons.edit : Icons.save),
      label: Text(isEditing ? "Update" : "Save"),
    );
  }
}