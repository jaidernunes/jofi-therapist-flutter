import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';

class QuizPatient extends StatefulWidget {
  final Map<String, dynamic> routeParams;

  const QuizPatient({
    super.key,
    required this.routeParams,
  });

  @override
  QuizPatientState createState() => QuizPatientState();
}

class QuizPatientState extends State<QuizPatient> {
  final api = Api();
  String? patientId;
  List<dynamic> questionnaires = [];

  @override
  void initState() {
    super.initState();
    patientId = widget.routeParams['patientId'];
    getPatientQuestionnaires();
  }

  Future<void> getPatientQuestionnaires() async {
    try {
      if (patientId == null) return;

      final response =
          await api.makeRequest('/questionnaires/patient/$patientId');

      if (response.statusCode == 200) {
        final questionnairesInfo = jsonDecode(response.body);

        setState(() {
          questionnaires = questionnairesInfo;
        });
      } else {
        print('Failed to get patient questionnaires: ${response.reasonPhrase}');
      }
    } catch (error) {
      print(error);
    }
  }

  String formatDate(String date) {
    try {
      final dateStrToDate = DateTime.parse(date);
      dateStrToDate.subtract(const Duration(hours: 3));
      final strDate = dateStrToDate.toIso8601String();
      final List<String> dateParts = strDate.split(RegExp(r'[\/:-T]'));
      return '${dateParts[2]}/${dateParts[1]}/${dateParts[0]} ${dateParts[3]}:${dateParts[4]}';
    } catch (error) {
      return 'DD/MM/YYYY';
    }
  }

  Map<String, String> dias = {
    'seg': 'Segunda',
    'ter': 'Terça',
    'qua': 'Quarta',
    'qui': 'Quinta',
    'sex': 'Sexta',
    'sab': 'Sábado',
    'dom': 'Domingo',
  };

  Widget formatAgendamento(Map<String, dynamic> item) {
    final frequencia = item['frequencia'];
    final hour = item['horario'];

    return Text(
      'Agendamento: ${frequencia.contains("Z") ? formatDate(frequencia) : '${dias[frequencia]} - $hour'}',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }

  Future<void> handleQuestionnaireDelete(String id) async {
    try {
      final response =
          await api.makeRequest('/questionnaire/sent/$id', method: 'DELETE');

      if (response.statusCode == 200) {
        await getPatientQuestionnaires();

        Fluttertoast.showToast(
          msg: 'Agendamento cancelado com sucesso!',
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        print('Failed to delete questionnaire: ${response.reasonPhrase}');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: questionnaires.map<Widget>((item) {
              return Container(
                key: ValueKey(item['id']),
                margin: const EdgeInsets.only(bottom: 37),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['Questionario']['titulo'] ?? 'Vazio',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4F4F4F),
                            ),
                          ),
                          if (item['frequencia'] != null)
                            formatAgendamento(item)
                          else
                            Text(
                              'Status: ${item['programado'] ? "enviado (agendado)" : (item['realizado'] ? "respondido" : "enviado")}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if (item['frequencia'] == null)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "QuizDatePatient",
                                    arguments: {"questionnarie": item},
                                  );
                                },
                                icon: Icon(
                                  item['realizado']
                                      ? Icons.check_circle
                                      : Icons.access_time,
                                  color: const Color(0xFFFF983D),
                                  size: 45,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "QuizGrafic",
                                    arguments: {"questionnarie": item},
                                  );
                                },
                                icon: const Icon(
                                  Icons.bar_chart,
                                  color: Color(0xFFFF983D),
                                  size: 45,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    "QuizDatePatient",
                                    arguments: {"questionnarie": item},
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Color(0xFFFF983D),
                                  size: 40,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text("Cancelar agendamento?"),
                                        content: const Text(
                                          "Essa ação não poderá ser desfeita!",
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text("Cancelar"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text("OK"),
                                            onPressed: () {
                                              handleQuestionnaireDelete(
                                                  item['id']);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 40,
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      /*floatingActionButton: SpeedDialAdd(
        onPress: () {
          Navigator.pushNamed(context, "AddQuiz");
        },
      ),*/
    );
  }
}
