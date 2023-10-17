import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/screens/tab_config.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const TabConfig(),
          settings: settings,
        );
      },
    );
  }
}
