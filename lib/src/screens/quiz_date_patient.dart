import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jofi_therapist_flutter/src/components/checkbox.dart';
import 'package:jofi_therapist_flutter/src/navigators/top_appbar.dart';
import 'package:jofi_therapist_flutter/src/screens/quizes.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';

class QuizDatePatient extends StatefulWidget {
  final Map<String, dynamic> routeParams;

  const QuizDatePatient({
    super.key,
    required this.routeParams,
  });

  @override
  QuizDatePatientState createState() => QuizDatePatientState();
}

class QuizDatePatientState extends State<QuizDatePatient> {
  final api = Api();
  Map<String, dynamic>? questionnaire;
  List<dynamic> questions = [];

  @override
  void initState() {
    super.initState();
    listQuestions();
  }

  String formatDate(String date) {
    try {
      final dateStrToDate = DateTime.parse(date);
      final formattedDate = dateStrToDate.subtract(const Duration(hours: 3));
      return '${formattedDate.day}/${formattedDate.month}/${formattedDate.year} ${formattedDate.hour}:${formattedDate.minute}:${formattedDate.second}';
    } catch (error) {
      return 'DD/MM/YYYY';
    }
  }

  Future<Response> fetchQuestions() async {
    try {
      if (questionnaire == null || questionnaire!['id'] == null) {
        throw Exception('Invalid questionnaire');
      }

      final response = await api.makeRequest(
        '/questionnaires/answer/${questionnaire!['id']}',
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (error) {
      rethrow;
    }
  }

  void listQuestions() async {
    try {
      final response = await fetchQuestions();

      final questionsInfo = json.decode(response.body);

      setState(() {
        questions = questionsInfo['Questionario']['Pergunta'];
      });
    } catch (error) {
      print(error);
    }
  }

  Widget multiplas(int id, String titulo, List<dynamic> multipla) {
    List<Map<String, dynamic>> multiplaList =
        multipla.cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Image.asset(Multipla),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4F4F4F),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), // Use SizedBox to add vertical spacing
        const Text(
          'Respostas selecionadas',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4F4F4F),
          ),
        ),
        CheckBox(multiplas: multiplaList), // Pass the correctly typed list
        const SizedBox(height: 50),
      ],
    );
  }

  Widget typeQuiz(int id, String titulo, String tipo, List<dynamic> multipla,
      List<dynamic> resposta, String melhorEscala, String piorEscala) {
    switch (tipo) {
      case 'multipla':
        return multiplas(
          id,
          titulo,
          multipla,
        );
      case 'escalanormal':
        return EscalaNormalWidget(
          id: id.toString(),
          titulo: titulo,
          escala: resposta.isNotEmpty ? resposta[0]['escala'] ?? "0" : "0",
        );
      case 'escalalikert':
        return EscalaLikertWidget(
          id: id.toString(),
          melhorEscala: melhorEscala,
          piorEscala: piorEscala,
          titulo: titulo,
          escala: resposta.isNotEmpty ? resposta[0]['escala'] : "",
        );
      case 'descritiva':
        return DescritivaWidget(
          id: id.toString(),
          titulo: titulo,
          resposta: resposta.isNotEmpty ? resposta[0]['resposta'] : "",
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: "QuizDatePatient"),

      // appBar: AppBar(
      //   title: const Text('QuizDatePatient'),
      // ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Text(
                'Paciente: ${questionnaire!['Paciente']['nome']}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                'Última resposta: ${questionnaire!['updatedAt'] != null ? formatDate(questionnaire!['updatedAt']) : 'DD/MM/YYYY'}',
                style: const TextStyle(
                  color: Color(0xFF4F4F4F),
                  fontSize: 16,
                ),
              ),
              Column(
                children: questions.map((question) {
                  return typeQuiz(
                    question['id'],
                    question['titulo'],
                    question['tipo'],
                    question['Multipla'],
                    question['Resposta'],
                    question['melhorEscala'],
                    question['piorEscala'],
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
