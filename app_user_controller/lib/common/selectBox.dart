import 'package:flutter/material.dart';

class SelectBox extends StatefulWidget {
  final Map<int, String> items;
  final ValueChanged<int?> onSelect;
  final int? initialValue;

  const SelectBox({
    super.key,
    required this.items,
    required this.onSelect,
    this.initialValue,
  });

  @override
  _SelectBoxState createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  int? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: selectedValue,
            items: widget.items.entries.map((entry) {
              return DropdownMenuItem<int>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              widget.onSelect(value);
            },
            hint: const Text('Seleccione una opción*'),
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}
