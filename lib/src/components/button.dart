import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback action;
  final bool disabled;

  const Button({
    super.key,
    required this.text,
    required this.action,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : action,
      child: Container(
        width: double.infinity,
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFFF983D),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF242424),
              fontFamily: 'Inter', // Use the 'Inter' font directly
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
