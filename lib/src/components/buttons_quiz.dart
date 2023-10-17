import 'package:flutter/material.dart';

class ButtonsQuiz extends StatelessWidget {
  final VoidCallback? actionRight;
  final VoidCallback? actionLeft;

  const ButtonsQuiz({super.key, this.actionRight, this.actionLeft});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (actionRight != null)
            GestureDetector(
              onTap: actionRight,
              child: Container(
                width: 96,
                height: 46,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFF983D), width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                      'assets/images/ArrowRight.png'), // Update the asset path as needed
                ),
              ),
            ),
          if (actionLeft != null)
            GestureDetector(
              onTap: actionLeft,
              child: Container(
                width: 96,
                height: 46,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFF983D), width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.asset(
                      'assets/images/ArrowLeft.png'), // Update the asset path as needed
                ),
              ),
            ),
        ],
      ),
    );
  }
}
