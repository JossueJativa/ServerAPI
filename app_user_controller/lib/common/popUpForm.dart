import 'package:app_user_controller/common/button.dart';
import 'package:app_user_controller/common/link.dart';
import 'package:flutter/material.dart';

class PopUpForm extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onPress;
  final BuildContext context;

  const PopUpForm({super.key, required this.title, required this.children, required this.onPress, required this.context});

  @override
  State<PopUpForm> createState() => _PopUpFormState();
}

class _PopUpFormState extends State<PopUpForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.children,
      ),
      actions: [
        Center(
          child: Button(
            onPress: widget.onPress, 
            text: 'Guardar', 
            color: Colors.green, 
            textColor: Colors.white,
          ),
        ),
        Link(
          text: 'Cancelar', 
          onPress: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
