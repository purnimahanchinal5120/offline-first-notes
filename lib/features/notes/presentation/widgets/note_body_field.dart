import 'package:flutter/material.dart';

class NoteBodyField extends StatelessWidget {
  final TextEditingController controller;

  const NoteBodyField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        expands: true,
        maxLines: null,
        minLines: null,
        decoration: const InputDecoration(
          hintText: "Start writing...",
          border: InputBorder.none,
        ),
      ),
    );
  }
}