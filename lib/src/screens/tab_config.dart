import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/components/button_config.dart';
import 'package:jofi_therapist_flutter/src/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabConfig extends StatefulWidget {
  final Function()? handleBack;

  const TabConfig({Key? key, this.handleBack}) : super(key: key);

  @override
  State<TabConfig> createState() => _TabConfigState();
}

class _TabConfigState extends State<TabConfig> {
  Future<void> handleLogout(BuildContext context) async {
    print("Logging out..."); // Add this line
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('@token');

    // Redirect to the login page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configurações"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            ButtonConfig(
              action: () {},
              text: "Dúvidas comuns",
              img: const AssetImage("assets/images/edit.png"),
            ),
            ButtonConfig(
              action: () => handleLogout(context),
              text: "Fazer Logout",
              img: const AssetImage("assets/images/exit.png"),
            ),
          ],
        ),
      ),
    );
  }
}
