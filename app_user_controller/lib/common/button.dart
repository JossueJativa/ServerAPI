import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPress;
  final String text;
  final Color color;
  final Color textColor;
  const Button(
      {super.key,
      required this.onPress,
      required this.text,
      required this.color,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      child: Text(text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
    );
  }
}
