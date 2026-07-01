import 'package:flutter/material.dart';

class NoteTitleField extends StatelessWidget {
  final TextEditingController controller;

  const NoteTitleField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
        hintText: "Title",
        border: InputBorder.none,
      ),
    );
  }
}