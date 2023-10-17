import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/screens/edit_quiz.dart';
import 'package:jofi_therapist_flutter/src/screens/tab_quiz.dart';
import 'package:jofi_therapist_flutter/src/screens/add_quiz.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'Quiz',
      onGenerateRoute: (settings) {
        print(settings);
        if (settings.name == 'Quiz') {
          return MaterialPageRoute(
            builder: (context) => const TabQuiz(),
            settings: settings,
          );
        } else if (settings.name == 'EditQuestion') {
          final Map<String, dynamic> routeParams =
              settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => EditQuiz(routeParams: routeParams),
            settings: settings,
          );
        } else if (settings.name == 'AddQuiz') {
          return MaterialPageRoute(
            builder: (context) => const AddQuiz(),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
