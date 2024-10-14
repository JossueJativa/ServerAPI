import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final bool obscureText;
  const Input({super.key, required this.text, required this.controller, required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: text,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
