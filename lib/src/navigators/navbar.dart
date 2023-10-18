import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/navigators/config_screen.dart';
import 'package:jofi_therapist_flutter/src/navigators/patient_screen.dart';
import 'package:jofi_therapist_flutter/src/navigators/quiz_screen.dart';
import 'package:jofi_therapist_flutter/themes/app_theme.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, -13), // changes position of shadow
          ),
        ],
      ),
      child: const DefaultTabController(
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
            indicatorColor: Colors.transparent,
            labelColor: AppTheme.standardOrange,
            unselectedLabelColor: AppTheme.iconGrey,
            labelStyle: AppTheme.navbarTextStyle,
            tabs: [
              Tab(
                  height: 90,
                  icon: ImageIcon(
                    AssetImage('assets/images/icon_pacientes.png'),
                    size: 46,
                  ),
                  child: Text(
                    'Pacientes',
                    style: AppTheme.navbarTextStyle,
                  )),
              Tab(
                  height: 90,
                  icon: ImageIcon(
                    AssetImage('assets/images/icon_config.png'),
                    size: 46,
                  ),
                  child: Text(
                    'Configurações',
                    style: AppTheme.navbarTextStyle,
                  )),
              Tab(
                  height: 90,
                  icon: ImageIcon(
                    AssetImage('assets/images/icon_questionario.png'),
                    size: 46,
                  ),
                  child: Text(
                    'Questionários',
                    style: AppTheme.navbarTextStyle,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
