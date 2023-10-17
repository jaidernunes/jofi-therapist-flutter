import 'package:flutter/material.dart';

class KeyboardAvoiding extends StatelessWidget {
  final Widget child;

  const KeyboardAvoiding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: child,
        ),
      ),
    );
  }
}
