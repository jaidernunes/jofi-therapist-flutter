import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Status bar color
      statusBarIconBrightness: Brightness.dark, // Status bar icons' color
      systemNavigationBarColor:
          Colors.white, // Navigation bar color (if applicable)
      systemNavigationBarIconBrightness:
          Brightness.dark, // Navigation bar icons' color (if applicable)
    ));

    return const SizedBox.shrink();
  }
}
