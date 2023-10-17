import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/navigators/config_screen.dart';
import 'package:jofi_therapist_flutter/src/navigators/patient_screen.dart';
import 'package:jofi_therapist_flutter/src/navigators/quiz_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(
          children: [
            PatientScreen(),
            ConfigScreen(),
            QuizScreen(),
          ],
        ),
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.white54,
          labelColor: Colors.orange,
          tabs: [
            Tab(
              icon: Icon(Icons.people_sharp),
              text: 'Pacientes',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'Configurações',
            ),
            Tab(
              icon: Icon(Icons.edit),
              text: 'Questionários',
            ),
          ],
        ),
      ),
    );
  }
}
