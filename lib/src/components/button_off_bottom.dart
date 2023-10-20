import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/themes/app_theme.dart';

class ButtonOffBottom extends StatelessWidget {
  final String text;
  final VoidCallback action;

  const ButtonOffBottom({
    super.key,
    required this.text,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        // width: 340,
        height: 46,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.standardOrange, width: 3),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF242424),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
