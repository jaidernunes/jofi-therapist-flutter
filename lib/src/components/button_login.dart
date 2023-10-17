import 'package:flutter/material.dart';

class ButtonLogin extends StatelessWidget {
  final String text;
  final VoidCallback action;

  const ButtonLogin({
    super.key,
    required this.text,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: 340,
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
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
