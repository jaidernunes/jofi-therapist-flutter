import 'package:flutter/material.dart';

class AjustHeightTextField extends StatelessWidget {
  final String placeholder;
  final double height;
  final String type;
  final String name;
  final Function(String) handleChange;
  final Function() handleBlur;
  final String values;

  const AjustHeightTextField({
    super.key,
    required this.placeholder,
    required this.height,
    required this.type,
    required this.name,
    required this.handleChange,
    required this.handleBlur,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF4F4F4F)),
          borderRadius: BorderRadius.circular(8),
        ),
        height: height,
        child: TextField(
          decoration: InputDecoration(
            hintText: placeholder,
            contentPadding: const EdgeInsets.all(8),
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
          onChanged: handleChange,
          onTap: handleBlur,
          controller: TextEditingController(text: values),
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
