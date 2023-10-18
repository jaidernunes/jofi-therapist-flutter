import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/components/buttons_quiz.dart';
import 'package:jofi_therapist_flutter/src/navigators/top_appbar.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class QuizGrafic extends StatefulWidget {
  final Map<String, dynamic>? routeParams;
  final String patientId; // Add the patientId argument

  const QuizGrafic({
    Key? key,
    this.routeParams,
    required this.patientId, // Initialize patientId
  }) : super(key: key);

  @override
  QuizGraficState createState() => QuizGraficState();
}

class QuizGraficState extends State<QuizGrafic> {
  final api = Api();
  List<Map<String, dynamic>> data = [
    {'mother': '01/02', 'earnings': 7},
    {'mother': '02/02', 'earnings': 2},
    {'mother': '03/02', 'earnings': 5},
    {'mother': '04/02', 'earnings': 4},
    {'mother': '05/02', 'earnings': 2},
    {'mother': '06/02', 'earnings': 6},
  ];

  List<Map<String, dynamic>> testData = [
    {
      "escala": 4,
      "QuestionarioPaciente": {
        "id": "3f7407ae-10bd-46bb-83da-cf1a9dc5c174",
        "updatedAt": "2023-02-06T18:10:05.372Z"
      }
    },
    {
      "escala": 1,
      "QuestionarioPaciente": {
        "id": "7ce05b0f-a7a2-4365-ab59-bb8b9f7d9fc7",
        "updatedAt": "2023-02-05T18:54:37.191Z"
      }
    },
    {
      "escala": 5,
      "QuestionarioPaciente": {
        "id": "65a37e85-443e-4081-8f54-3f7c28ff29fa",
        "updatedAt": "2023-02-04T18:54:30.031Z"
      }
    },
    {
      "escala": 3,
      "QuestionarioPaciente": {
        "id": "a28a1a3f-e5c4-4f8e-91e5-3eb89591018c",
        "updatedAt": "2023-02-03T19:04:26.138Z"
      }
    }
  ];

  Map<String, dynamic>? questionnaire;
  List<dynamic> questions = [];
  List<Map<String, dynamic>> answers = [];
  int currentQuestion = 0;

  @override
  void initState() {
    super.initState();
    listQuestions();
  }

  String formatDate(String date, [bool fullDate = false]) {
    try {
      final dateStrToDate = DateTime.parse(date);
      dateStrToDate.subtract(const Duration(hours: 3));
      final strDate = dateStrToDate.toIso8601String();
      final List<String> dateParts = strDate.split(RegExp(r'[\/:-T]'));
      return fullDate
          ? '${dateParts[2]}/${dateParts[1]}/${dateParts[0]} ${dateParts[3]}:${dateParts[4]}'
          : '${dateParts[2]}/${dateParts[1]}';
    } catch (error) {
      return 'DD/MM/YYYY';
    }
  }

  void getAnswers() async {
    final pacientId = questionnaire?['Paciente']?.id;
    if (pacientId == null) return;

    final question = questions.isNotEmpty ? questions[currentQuestion] : null;
    if (question == null ||
        (question['tipo'] != 'escalanormal' &&
            question['tipo'] != 'escalalikert')) {
      setState(() {
        answers = [];
      });
      return;
    }

    try {
      final response = await api
          .makeRequest('/questionnaires/answer/$pacientId/${question['id']}');
      final data = json.decode(response.body);

      data.forEach((element) {
        element['updatedAt'] =
            formatDate(element['QuestionarioPaciente']['updatedAt']);
        element.remove('QuestionarioPaciente');
      });

      setState(() {
        answers = data;
      });
    } catch (error) {
      print(error);
      setState(() {
        answers = [];
      });
    }
  }

  void listQuestions() async {
    final questionnaireId = questionnaire?['id'];
    if (questionnaireId == null) return;

    try {
      final response =
          await api.makeRequest('/questionnaires/answer/$questionnaireId');
      final data = json.decode(response.body);

      setState(() {
        questions = data['Questionario']['Pergunta'];
      });
    } catch (error) {
      print('error: $error');
    }
  }

  void nextQuestion() {
    setState(() {
      currentQuestion++;
    });
    getAnswers();
  }

  void previousQuestion() {
    setState(() {
      currentQuestion--;
    });
    getAnswers();
  }

  Widget currentQuestionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            //Image.asset(Escala),
            SizedBox(
              width: double.infinity,
              child: Text(
                questions.isNotEmpty
                    ? questions[currentQuestion]['titulo']
                    : 'Vazio',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4F4F4F),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            height: 300, // Adjust the height according to your design
            child: answers.isNotEmpty
                ? SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat.yMd(),
                    ),
                    primaryYAxis: NumericAxis(),
                    series: <ChartSeries>[
                      AreaSeries<Map<String, dynamic>, DateTime>(
                        dataSource: answers,
                        xValueMapper: (Map<String, dynamic> data, _) =>
                            DateTime.parse(data['updatedAt']),
                        yValueMapper: (Map<String, dynamic> data, _) =>
                            data['escala'],
                        color: const Color(0xFFFF983D),
                      ),
                    ],
                  )
                : const Text(
                    'Gráfico Indisponível Para Esta Questão',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: "QuizGrafic"),

      // appBar: AppBar(
      //   title: const Text('QuizGrafic'),
      // ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Paciente: ${questionnaire!['Paciente']['nome']}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: Text(
                'Última resposta: ${questionnaire!['updatedAt'] != null ? formatDate(questionnaire!['updatedAt'], true) : 'DD/MM/YYYY'}',
                style: const TextStyle(
                  color: Color(0xFF4F4F4F),
                  fontSize: 16,
                ),
              ),
            ),
            currentQuestionWidget(),
            ButtonsQuiz(
              actionLeft: currentQuestion < questions.length - 1
                  ? () => nextQuestion()
                  : null,
              actionRight:
                  currentQuestion > 0 ? () => previousQuestion() : null,
            ),
          ],
        ),
      ),
    );
  }
}
