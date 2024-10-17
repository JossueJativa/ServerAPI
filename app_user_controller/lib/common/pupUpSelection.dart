import 'package:flutter/material.dart';

class PupUpSelection extends StatelessWidget {
  final String title;
  final String option1;
  final String option2;
  final VoidCallback onPressYes;
  final VoidCallback onPressNo;
  const PupUpSelection(
      {super.key,
      required this.onPressYes,
      required this.onPressNo,
      required this.title,
      required this.option1,
      required this.option2});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              onPressYes();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,),
            child: Text(option1, style: const TextStyle(color: Colors.white),),
          ),
          ElevatedButton(
            onPressed: () {
              onPressNo();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,),
            child: Text(option2, style: const TextStyle(color: Colors.white),),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        )
      ],
    );
  }
}
