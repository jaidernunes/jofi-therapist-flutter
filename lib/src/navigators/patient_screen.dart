import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/screens/message_terapeuta.dart';
import 'package:jofi_therapist_flutter/src/screens/tab_patients.dart';
import 'package:jofi_therapist_flutter/src/screens/summary.dart';
import 'package:jofi_therapist_flutter/src/screens/add_patient.dart';
import 'package:jofi_therapist_flutter/src/screens/quiz_patient.dart';
import 'package:jofi_therapist_flutter/src/screens/quiz_date_patient.dart';
import 'package:jofi_therapist_flutter/src/screens/quiz_grafic.dart';
import 'package:jofi_therapist_flutter/src/screens/grafic2.dart';

class PatientScreen extends StatelessWidget {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: 'Home',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'Home':
            return MaterialPageRoute(
              builder: (context) => const TabPatients(),
              settings: settings,
            );
          case 'Summary':
            final patientId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => Summary(
                route: {'id': patientId},
              ),
              settings: settings,
            );
          case 'MessageTerapeuta':
            final Map<String, dynamic> routeParams =
                settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => MessageTerapeuta(routeParams: routeParams),
              settings: settings,
            );
          case 'QuizPatient':
            final Map<String, dynamic> routeParams =
                settings.arguments as Map<String, dynamic>;
            final String patientId =
                routeParams['patientId']; // Extract the patientId
            return MaterialPageRoute(
              builder: (context) =>
                  QuizPatient(routeParams: {'patientId': patientId}),
              settings: settings,
            );
          case 'QuizDatePatient':
            final Map<String, dynamic> routeParams =
                settings.arguments as Map<String, dynamic>;
            final String patientId = routeParams['patientId'];
            return MaterialPageRoute(
              builder: (context) =>
                  QuizDatePatient(routeParams: {'patientId': patientId}),
              settings: settings,
            );
          case 'QuizGrafic':
            final Map<String, dynamic> routeParams =
                settings.arguments as Map<String, dynamic>;
            final String patientId = routeParams['patientId'];
            return MaterialPageRoute(
              builder: (context) => QuizGrafic(patientId: patientId),
              settings: settings,
            );
          case 'AddPatient':
            return MaterialPageRoute(
              builder: (context) => const AddPatient(),
              settings: settings,
            );

          case 'Grafic2':
            final Map<String, dynamic> routeParams =
                settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => Grafic2(routeParams: routeParams),
              settings: settings,
            );

          default:
            return null;
        }
      },
    );
  }
}
