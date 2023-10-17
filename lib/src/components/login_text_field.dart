import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final String placeholder;
  final String type;
  final String name;
  final Function handleChange;
  final Function handleBlur;
  final String values;

  const LoginTextField({
    super.key,
    required this.placeholder,
    required this.type,
    required this.name,
    required this.handleChange,
    required this.handleBlur,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4F4F4F)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: placeholder,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            handleChange(value);
          },
          onFieldSubmitted: (value) {
            handleBlur();
          },
          initialValue: values,
        ),
      ),
    );
  }
}
