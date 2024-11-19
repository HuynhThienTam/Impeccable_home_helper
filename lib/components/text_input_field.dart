import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;

  const TextInputField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14.0,
          horizontal: 16.0,
        ),
      ),
    );
  }
}
