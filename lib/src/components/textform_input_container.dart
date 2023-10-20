import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/themes/app_theme.dart';

class TextFormInputContainer extends StatelessWidget {
  final Widget child;

  const TextFormInputContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.only(left: 15, bottom: 3),
      alignment: Alignment.centerLeft,
      height: 46,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.offBlack2,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
