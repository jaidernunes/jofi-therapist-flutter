import 'package:flutter/material.dart';

class RadioButtons extends StatefulWidget {
  final String check;
  final String melhorEscala;
  final String piorEscala;

  const RadioButtons({
    super.key,
    required this.check,
    required this.melhorEscala,
    required this.piorEscala,
  });

  @override
  _RadioButtonsState createState() => _RadioButtonsState();
}

class _RadioButtonsState extends State<RadioButtons> {
  String selectedValue = "";

  @override
  void initState() {
    super.initState();
    selectedValue = widget.check;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.piorEscala.isEmpty ? "Muito Pior" : widget.piorEscala,
            ),
            Text(
              widget.melhorEscala.isEmpty
                  ? "Muito Melhor"
                  : widget.melhorEscala,
            ),
          ],
        ),
        const SizedBox(height: 13),
        Column(
          children: ["1", "2", "3", "4", "5"].map((value) {
            return RadioListTile(
              title: Text(value),
              value: value,
              groupValue: selectedValue,
              onChanged: (newValue) {
                setState(() {
                  selectedValue = newValue.toString();
                });
                // Handle the selected value here, e.g., send it to a parent widget.
                // You can use a callback function to pass this value.
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
