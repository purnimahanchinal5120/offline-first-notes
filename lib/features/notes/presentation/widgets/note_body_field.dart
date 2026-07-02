import 'package:flutter/material.dart';

class NoteBodyField extends StatelessWidget {
  final TextEditingController controller;

  const NoteBodyField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      expands: true,
      maxLines: null,
      minLines: null,
      style: const TextStyle(
        fontSize: 16,
        height: 1.7,
        color: Color(0xff374151),
      ),
      decoration: InputDecoration(
        hintText: "Start writing your thoughts...",
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
        ),
        alignLabelWithHint: true,
        filled: true,
        fillColor: const Color(0xffF8FAFC),
        contentPadding: const EdgeInsets.all(20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Color(0xff4F46E5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Color(0xff4F46E5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xff4F46E5),
            width: 2,
          ),
        ),
      ),
    );
  }
}