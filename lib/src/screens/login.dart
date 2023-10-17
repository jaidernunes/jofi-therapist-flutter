import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/navigators/navbar.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  Future<void> checkToken() async {
    final api = Api();
    final tokenValid = await api.checkToken();

    if (tokenValid) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NavBar(),
        ),
      );
    }
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      final pass = _passwordController.text;

      setState(() {
        isLoading = true;
      });

      try {
        print('enviando credenciais: $email, $pass');

        final api = Api();
        final response = await api.makeRequest(
          "/therapist/login",
          method: 'POST',
          data: {
            'email': email,
            'senha': pass,
          },
        );

        print(response.body);

        if (response.statusCode == 200) {
          final newToken =
              response.body.replaceAll('"', ''); // Remove double quotes

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('@token', newToken);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NavBar(),
            ),
          );
        } else {
          final errorMessage = 'O login falhou: ${response.reasonPhrase}';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (error) {
        print('deu um erro: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Credenciais inválidas! Confira o email e senha e tente novamente.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange), // Loading indicator color
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/Logo.png'),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'E-mail cadastrado',
                                hintText: 'E-mail',
                                labelStyle: TextStyle(
                                  color: Colors.black, // Label text color
                                  fontSize: 16, // Label text size
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black, // Text input color
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'É preciso de um e-mail para acessar o aplicativo';
                                }
                                final emailPattern = RegExp(
                                  r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
                                );
                                if (!emailPattern.hasMatch(value)) {
                                  return 'Por favor, digite um email válido';
                                }
                                return null; // Validation passed
                              },
                            ),
                            const SizedBox(
                                height: 16), // Spacing between fields
                            TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Digite sua senha',
                                hintText: 'Senha',
                                labelStyle: TextStyle(
                                  color: Colors.black, // Label text color
                                  fontSize: 16, // Label text size
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.black, // Text input color
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'É preciso de uma senha para acessar o aplicativo';
                                }
                                if (value.length < 8) {
                                  return 'Sua senha deve ter no mínimo 8 caracteres';
                                }
                                return null; // Validation passed
                              },
                            ),
                            const SizedBox(height: 24), // Spacing before button
                            ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.orange, // Button background color
                                textStyle: const TextStyle(
                                  color: Colors.white, // Button text color
                                  fontSize: 18, // Button text size
                                ),
                              ),
                              child: const Text('Entrar'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
