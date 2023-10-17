import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      flex: 1,
      child: SizedBox(),
    );
  }
}
