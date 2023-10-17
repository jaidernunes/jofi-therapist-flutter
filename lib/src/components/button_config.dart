import 'package:flutter/material.dart';

class ButtonConfig extends StatelessWidget {
  final VoidCallback action;
  final String text;
  final ImageProvider<Object> img;

  const ButtonConfig({
    Key? key,
    required this.action,
    required this.text,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                color: Color(0xFF4F4F4F),
              ),
            ),
            const SizedBox(width: 10),
            Image(
              image: img,
              width: 32,
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
