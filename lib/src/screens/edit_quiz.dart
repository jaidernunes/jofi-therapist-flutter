import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/components/escala_0_a_10.dart';
import 'package:jofi_therapist_flutter/src/components/escala_likert_quiz.dart';
import 'package:jofi_therapist_flutter/src/components/pergunta_descritiva.dart';
import 'package:jofi_therapist_flutter/src/components/quiz_check.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';

class EditQuiz extends StatefulWidget {
  final Map<String, dynamic> routeParams;

  const EditQuiz({
    Key? key,
    required this.routeParams,
  }) : super(key: key);

  @override
  EditQuizState createState() => EditQuizState();
}

class EditQuizState extends State<EditQuiz> {
  final api = Api();
  bool showSpeedDial = false;
  String titleQuiz = "";
  List<Map<String, dynamic>> quizes = [];
  List<Map<String, dynamic>> actualQuizes = [];

  @override
  void initState() {
    super.initState();
    getQuestionnarieInfo();
  }

  Future<Map<String, dynamic>> fetchQuestionnaireInfo(String id) async {
    final response = await api.makeRequest('/questionnaire/$id');
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load questionnaire info');
    }
  }

  void getQuestionnarieInfo() async {
    try {
      final questionnarieInfo =
          await fetchQuestionnaireInfo(widget.routeParams['id']);

      setState(() {
        titleQuiz = questionnarieInfo['titulo'];

        actualQuizes =
            questionnarieInfo['Pergunta'].map<Map<String, dynamic>>((item) {
          final tipo = item['tipo'];
          final multiplas = item['Multipla'] != null
              ? item['Multipla']
                  .map<String>((multiplaItem) => multiplaItem['texto'])
                  .toList()
              : [""];

          return {
            'tipo': tiposFormatted[tipo],
            'multiplas': multiplas,
          };
        }).toList();
      });
    } catch (error) {
      print(error);
    }
  }

  final Map<String, int> tiposFormatted = {
    'multipla': 1,
    'escalanormal': 2,
    'escalalikert': 3,
    'descritiva': 4,
  };

  Widget selectQuiz(Map<String, dynamic> quizSelected, int index) {
    switch (quizSelected['tipo']) {
      case 1:
        return QuizCheck(
          quest: quizSelected,
          changeQuest: (newQuest) {
            setState(() {
              quizes[index] = newQuest;
            });
          },
          removeQuiz: (int quizIndex) {
            // Modify removeQuiz to accept an int argument
            setState(() {
              quizes.removeAt(quizIndex);
            });
          },
          index: index,
        );
      case 2:
        return Escala0a10(
          quest: quizSelected,
          changeQuest: (newQuest) {
            setState(() {
              quizes[index] = newQuest;
            });
          },
          removeQuiz: (int quizIndex) {
            // Modify removeQuiz to accept an int argument
            setState(() {
              quizes.removeAt(quizIndex);
            });
          },
          index: index,
        );
      case 3:
        return EscalaLikertQuiz(
          quest: quizSelected,
          changeQuest: (newQuest) {
            setState(() {
              quizes[index] = newQuest;
            });
          },
          removeQuiz: (int quizIndex) {
            // Modify removeQuiz to accept an int argument
            setState(() {
              quizes.removeAt(quizIndex);
            });
          },
          index: index,
        );
      case 4:
        return PerguntaDescritiva(
          quest: quizSelected,
          changeQuest: (newQuest) {
            setState(() {
              quizes[index] = newQuest;
            });
          },
          removeQuiz: (int quizIndex) {
            // Modify removeQuiz to accept an int argument
            setState(() {
              quizes.removeAt(quizIndex);
            });
          },
          index: index,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Question'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Título do questionário: $titleQuiz',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Perguntas',
                style: TextStyle(
                  color: Color(0xFF4F4F4F),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              Column(
                children: actualQuizes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final actualQuiz = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: quizes.length == index + 1 ? 200 : 40,
                    ),
                    child: selectQuiz(actualQuiz, index),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
