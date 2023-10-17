import 'package:flutter/material.dart';

class ButtonDisabled extends StatelessWidget {
  final VoidCallback action;
  final String text;

  const ButtonDisabled({
    super.key,
    required this.action,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: Container(
        width: double.infinity,
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF999999),
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
