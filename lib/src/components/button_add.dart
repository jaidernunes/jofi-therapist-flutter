import 'package:flutter/material.dart';

class ButtonAdd extends StatelessWidget {
  const ButtonAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: const Color(0xFFFF983D),
      ),
      child: const Center(
        child: Text(
          '+',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
