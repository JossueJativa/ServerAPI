import 'package:flutter/material.dart';

class Infomessage {
  final String message;
  final Color color;
  final Color textColor;
  final IconData icon;
  final double size;

  Infomessage({
    required this.message,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.size,
  });

  void show(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                icon,
                size: size,
                color: textColor,
              ),
              const SizedBox(width: 10),
              Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: size * 0.75,
                ),
              ),
            ],
          ),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        ),
      );
    });
  }
}
