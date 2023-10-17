import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/components/escala_0_a_10.dart';
import 'package:jofi_therapist_flutter/src/components/escala_likert_quiz.dart';
import 'package:jofi_therapist_flutter/src/components/pergunta_descritiva.dart';
import 'package:jofi_therapist_flutter/src/components/quiz_check.dart';
import 'package:jofi_therapist_flutter/src/components/speed_dial.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';
import 'package:jofi_therapist_flutter/src/server/token.dart';
import 'package:uuid/uuid.dart';

class AddQuiz extends StatefulWidget {
  const AddQuiz({super.key});

  @override
  AddQuizState createState() => AddQuizState();
}

class AddQuizState extends State<AddQuiz> {
  final Api api = Api();
  bool showSpeedDial = false;
  bool letGoBack = false;
  List<Map<String, dynamic>> quizes = [];
  bool preventDuplication = false;
  final Map tiposFormatted = {
    1: "multiplas",
    2: "escalanormal",
    3: "escalalikert",
    4: "descritiva",
  };
  TextEditingController titleQuizController = TextEditingController();
  final ScrollController scrollViewController = ScrollController();

  @override
  void dispose() {
    titleQuizController.dispose();
    scrollViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Adicionar questionário'),
          backgroundColor: Colors.orange,
        ),
        body: SingleChildScrollView(
          controller: scrollViewController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: titleQuizController,
                  onChanged: (value) {
                    // Handle titleQuiz changes
                  },
                  decoration: const InputDecoration(
                    hintText: 'Digite o título do Questionário',
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Perguntas',
                  style: TextStyle(
                    color: Color(0xFF4F4F4F),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                for (int index = 0; index < quizes.length; index++)
                  Container(
                    margin: EdgeInsets.only(
                      bottom: quizes.length == index + 1 ? 200 : 40,
                    ),
                    child: selectQuiz(quizes[index], index),
                  ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 400,
                  child: SpeedDial(
                    openSpeed: () {
                      setState(() {
                        showSpeedDial = true;
                      });
                    },
                    showSpeedDial: showSpeedDial,
                    onPress: (int id) {
                      final selectedType = tiposFormatted[id];
                      addQuiz(selectedType);
                      setState(() {
                        showSpeedDial = false;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                FloatingActionButton(
                  onPressed: () {
                    handleSave();
                  },
                  child: const Icon(Icons.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addQuiz(tipo) {
    setState(() {
      const uuid = Uuid();
      quizes.add({
        'id': uuid.v4(),
        'tipo': tipo,
        'titulo': '',
        'piorEscala': '',
        'melhorEscala': '',
        'multiplas': [''],
      });
    });
  }

  Widget selectQuiz(Map<String, dynamic> quizSelected, int index) {
    print(quizSelected);
    switch (quizSelected['tipo']) {
      case 'multiplas':
        return QuizCheck(
          quest: quizSelected,
          changeQuest: setState,
          removeQuiz: removeQuiz,
          index: index,
        );
      case "escalanormal":
        return Escala0a10(
          quest: quizSelected,
          changeQuest: setState,
          removeQuiz: removeQuiz,
          index: index,
        );
      case "escalalikert":
        return EscalaLikertQuiz(
          quest: quizSelected,
          changeQuest: setState,
          removeQuiz: removeQuiz,
          index: index,
        );
      case "descritiva":
        return PerguntaDescritiva(
          quest: quizSelected,
          changeQuest: setState,
          removeQuiz: removeQuiz,
          index: index,
        );
      default:
        return const SizedBox();
    }
  }

  bool validateInputs() {
    if (titleQuizController.text.isEmpty) {
      throwInvalidInputsError('Título do questionário vazio!');
      return false;
    }

    if (quizes.isEmpty) {
      throwInvalidInputsError('Não há perguntas no questionário');
      return false;
    }

    bool hasInvalidQuestions = false;

    for (int index = 0; index < quizes.length; index++) {
      final Map<String, dynamic> quiz = quizes[index];

      if (quiz['titulo'].isEmpty) {
        throwInvalidInputsError('Título da pergunta ${index + 1} vazio!');
        hasInvalidQuestions = true;
      }

      if ((quiz['tipo'] == 2 || quiz['tipo'] == 3) &&
          (quiz['piorEscala'].isEmpty || quiz['melhorEscala'].isEmpty)) {
        throwInvalidInputsError(
            'Textos inválidos para as escalas da pergunta ${index + 1}!');
        hasInvalidQuestions = true;
      }

      if (quiz['tipo'] == 1 &&
          (quiz['multiplas'] as List<String>).any((choice) => choice.isEmpty)) {
        throwInvalidInputsError(
            'Textos inválidos para as escolhas da pergunta ${index + 1}!');
        hasInvalidQuestions = true;
      }
    }

    return !hasInvalidQuestions;
  }

  void throwInvalidInputsError(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dados inválidos'),
          content: Text(error),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void removeQuiz(int id) {
    setState(() {
      quizes.removeWhere((value) => value['id'] == id);
    });
  }

  Future<void> handleSave() async {
    if (!validateInputs()) return;

    setState(() {
      preventDuplication = true;
    });

    try {
      final userId = await getUserId();
      final questionnaireResponse = await api.makeRequest(
        '/questionnaire/$userId',
        method: 'POST',
        data: {
          'titulo': titleQuizController.text,
        },
      );

      final Map<String, dynamic> responseBody =
          jsonDecode(questionnaireResponse.body);
      final questionnaireId = responseBody['id'];

      final formattedQuizzes = quizes.map((quizData) {
        final tipo = quizData['tipo'];
        final multiplas = quizData['multiplas'] as List<String>;
        final piorEscala = quizData['piorEscala'];
        final melhorEscala = quizData['melhorEscala'];
        final titulo = quizData['titulo'];

        final formattedQuiz = {
          'titulo': titulo,
          'tipo': tiposFormatted[tipo],
        };

        if (tipo == 1) {
          formattedQuiz['multiplas'] =
              multiplas.where((choice) => choice.isNotEmpty).toList();
        } else if (tipo == 2 || tipo == 3) {
          formattedQuiz['piorEscala'] = piorEscala;
          formattedQuiz['melhorEscala'] = melhorEscala;
        }

        return formattedQuiz;
      }).toList();

      await api.makeRequest(
        '/questionnaire/questions/$questionnaireId',
        method: 'POST',
        data: {
          'questions': formattedQuizzes,
        },
      );

      setState(() {
        letGoBack = true;
      });
    } catch (error) {
      setState(() {
        preventDuplication = false;
        letGoBack = false;
      });
      print(error);
    }
  }

  Future<bool> _onWillPop() async {
    if (!letGoBack) {
      // Show a confirmation dialog to prevent leaving the screen
      bool discardChanges = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Descartar questionário?'),
            content: const Text('Ao sair dessa página os dados serão perdidos'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User wants to stay
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User confirmed discard
                },
                child: const Text('Descartar'),
              ),
            ],
          );
        },
      );

      return discardChanges;
    }

    // No unsaved changes, allow leaving the screen
    return true;
  }
}
