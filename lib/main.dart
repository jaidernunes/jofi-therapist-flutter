import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/navigators/navbar.dart';
import 'package:jofi_therapist_flutter/src/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('@token');

  runApp(JofiTherapist(token: token));
}

class JofiTherapist extends StatelessWidget {
  final String? token;

  const JofiTherapist({Key? key, this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jofi Terapeuta',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: token != null ? const NavBar() : const Login(),
      routes: {
        '/login': (context) => const Login(),
      },
    );
  }
}
