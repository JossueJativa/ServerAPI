import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  final Icon? icon;
  const Link({super.key, required this.text, required this.onPress, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          if (icon != null) icon!,
        ],
      ),
    );
  }
}
