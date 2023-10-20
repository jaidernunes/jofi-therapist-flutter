import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:jofi_therapist_flutter/src/components/button_off_bottom.dart';
import 'package:jofi_therapist_flutter/src/components/button_standard_bottom.dart';
import 'package:jofi_therapist_flutter/src/components/emergency_contact_card.dart';
import 'package:jofi_therapist_flutter/src/components/status_bar.dart';
import 'package:jofi_therapist_flutter/src/navigators/top_appbar.dart';
import 'package:jofi_therapist_flutter/src/navigators/top_appbar_edit.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';
import 'package:jofi_therapist_flutter/src/server/token.dart';
import 'package:jofi_therapist_flutter/themes/app_theme.dart';

class Summary extends StatefulWidget {
  final Map<String, dynamic> route;

  const Summary({
    super.key,
    required this.route,
  });

  @override
  SummaryState createState() => SummaryState();
}

class SummaryState extends State<Summary> {
  final api = Api();
  String? code;
  Map<String, dynamic> patient = {};
  String selectedQuestionnaire = "";
  String? therapistId;
  List<String> questionnaires = [];
  bool isDatePickerVisible = false;
  bool isTimePickerVisible = false;
  bool modalVisible = false;
  bool choiceHour = false;
  List<String> dias = [];

  @override
  void initState() {
    super.initState();
  }

  void showToastWithGravity() {
    Fluttertoast.showToast(
        msg: "Convite copiado",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  Future<void> generateCode() async {
    try {
      final Map<String, dynamic> dataToSent = {
        'pacienteId': widget.route['id'],
        'terapeutaId': therapistId,
      };

      final Response response = await api.makeRequest('/therapist/patient',
          method: 'POST', data: dataToSent);

      if (response.statusCode == 200) {
        final Map<String, dynamic> codeGenerated = jsonDecode(response.body);

        setState(() {
          code = codeGenerated['data'];
        });
      } else {
        throw Exception('Failed to generate code: ${response.reasonPhrase}');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<Map<String, dynamic>> getPatientInfo() async {
    try {
      therapistId = await getUserId();

      final Response response =
          await api.makeRequest('/patient/${widget.route['id']}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> patientInfo = json.decode(response.body);

        return patientInfo;
      } else {
        throw Exception('Failed to get patient info: ${response.reasonPhrase}');
      }
    } catch (error) {
      print(error);
      return {};
    }
  }

  void handleOpenFrequencyModal(String value) {
    setState(() {
      selectedQuestionnaire = value;
    });
    //TODO:Implement this
    // openFrequencyModal();
  }

  Future<void> sendQuestionnaire(
      String? freq, String? hour, List<String>? dias) async {
    try {
      final patientId = widget.route['id'];
      final apiUrl = '/questionnaire/send/$selectedQuestionnaire';

      if (dias!.isEmpty) {
        await api.makeRequest(apiUrl,
            data: {
              'pacienteId': patientId,
              'frequencia': freq,
            },
            method: 'POST');
      } else {
        await Future.forEach(dias, (dia) async {
          await api.makeRequest(apiUrl,
              data: {
                'pacienteId': patientId,
                'frequencia': dia,
                'horario': hour,
              },
              method: 'POST');
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void onSelectedOption(String value) {
    setState(() {
      choiceHour = false;
    });

    if (value == 'per') {
      setState(() {
        isDatePickerVisible = true;
      });
    } else if (value == 'mul') {
      setState(() {
        modalVisible = true;
      });
    } else if (value == 'mulhor') {
      setState(() {
        choiceHour = true;
        modalVisible = true;
      });
    } else {
      confirmSend(value, null, null);
    }
  }

  void confirmSend(String? freq, String? hour, List<String>? dias) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enviar questionário?'),
          content: const Text('O questionário será enviado ao paciente!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Não, cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                sendQuestionnaire(freq, hour, dias);
              },
              child: const Text('Sim, enviar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendMultipleDays() async {
    try {
      setState(() {
        modalVisible = false;
      });

      if (choiceHour) {
        setState(() {
          isTimePickerVisible = true;
        });
      } else {
        final patientId = widget.route['id'];
        final apiUrl = '/questionnaire/send/$selectedQuestionnaire';

        List<String> diasEscolhidos = List<String>.from(dias);
        setState(() {
          dias = [];
        });

        await Future.forEach(diasEscolhidos, (dia) async {
          await api.makeRequest(apiUrl,
              data: {
                'pacienteId': patientId,
                'frequencia': dia,
              },
              method: 'POST');
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void hideDatePicker() {
    setState(() {
      isDatePickerVisible = false;
    });
  }

  void hideTimePicker() {
    setState(() {
      isTimePickerVisible = false;
    });
  }

  void handleConfirmDatetime(DateTime date) {
    hideDatePicker();

    confirmSend(date.toString(), null, null);
  }

  void handleConfirmTime(DateTime date) {
    hideTimePicker();

    DateTime dateStrToDate = date;
    dateStrToDate = dateStrToDate.subtract(const Duration(hours: 3));
    String strDate = dateStrToDate.toIso8601String();
    List<String> dateParts = strDate.split(RegExp(r'[/:\-T]'));
    String hour = '${dateParts[3]}:${dateParts[4]}';

    List<String> diasEscolhidos = List<String>.from(dias);
    setState(() {
      dias = [];
    });

    confirmSend(null, hour, diasEscolhidos);
  }

  Future<void> listQuestionnaires() async {
    try {
      final userId = await getUserId();

      final response = await api.makeRequest(
        '/questionnaires/therapist/$userId',
        method: 'GET',
      );

      if (response.statusCode == 200) {
        final questionnairesInfo = json.decode(response.body);

        final questionnairesFormatted = questionnairesInfo.map((item) {
          return {
            'label': item['titulo'],
            'value': item['id'],
          };
        }).toList();

        setState(() {
          questionnaires = questionnairesFormatted;
        });
      } else {
        // Handle the case when the API request returns an error.
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBarEdit(title: "Paciente"),

      // appBar: AppBar(
      //   title: const Text("Paciente"),
      //   backgroundColor: Colors.orange,
      // ),
      body: Stack(
        children: [
          const StatusBar(),
          FutureBuilder<Map<String, dynamic>>(
            future: getPatientInfo(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error.toString()}'),
                );
              } else {
                patient = snapshot.data!;

                return SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   'Nome:',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Text(
                        patient['nome'] ?? 'Não informado',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // const Text(
                      //   'Email:',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Text(
                        patient['email'] ?? 'Não informado',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // const Text(
                      //   'Telefone:',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Text(
                        patient['telefone'] ?? 'Não informado',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Data de Nascimento',
                        style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                          color: AppTheme.offBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        patient['nascimento'] ?? 'Não informado',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Profissão: ${patient['profissao'] ?? 'Não informado'}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.offBlack,
                        ),
                      ),
                      // Text(
                      //   patient['profissao'] ?? 'Não informado',
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      // const Text(
                      //   'Descrição:',
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Text(
                        patient['descricao'] ?? 'Não informado',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.offBlack,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Observações:',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.offBlack,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        patient['observacoes'] ?? 'Não informado',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contatos de Emergência:',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.offBlack,
                            ),
                          ),
                          Visibility(
                            visible: !modalVisible,
                            child:
                                // Container(
                                //   padding: const EdgeInsets.all(16.0),
                                //   margin: const EdgeInsets.all(16.0),
                                //   width: double.infinity,
                                //   decoration: BoxDecoration(
                                //     border: Border.all(color: AppTheme.standardOrange, width: 3),
                                //     borderRadius: BorderRadius.circular(8),
                                //     color: AppTheme.standardLightOrange,
                                //   ),
                                //   child: Row(
                                //     children: [
                                //       Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           // const Text(
                                //           //   'Nome:',
                                //           //   style: TextStyle(
                                //           //     fontSize: 16,
                                //           //     fontWeight: FontWeight.bold,
                                //           //   ),
                                //           // ),
                                //           Text(
                                //             patient['ContatoEmergencia']?['nome'] ??
                                //                 'Não informado',
                                //             style: const TextStyle(
                                //               fontSize: 16,
                                //             ),
                                //           ),
                                //           const SizedBox(height: 20),
                                //           // const Text(
                                //           //   'Relação:',
                                //           //   style: TextStyle(
                                //           //     fontSize: 16,
                                //           //     fontWeight: FontWeight.bold,
                                //           //   ),
                                //           // ),
                                //           Text(
                                //             patient['ContatoEmergencia']
                                //                     ?['relacao'] ??
                                //                 'Não informado',
                                //             style: const TextStyle(
                                //               fontSize: 16,
                                //             ),
                                //           ),
                                //           const SizedBox(height: 20),
                                //           // const Text(
                                //           //   'Telefone:',
                                //           //   style: TextStyle(
                                //           //     fontSize: 16,
                                //           //     fontWeight: FontWeight.bold,
                                //           //   ),
                                //           // ),
                                //           Text(
                                //             patient['ContatoEmergencia']
                                //                     ?['telefone'] ??
                                //                 'Não informado',
                                //             style: const TextStyle(
                                //               fontSize: 16,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                EmergencyContactCard(patient: patient),
                          ),

                          // BOTÕES BOTTOM
                          ButtonOffBottom(
                              text: 'Gerar convite', action: () => {}),
                          ButtonOffBottom(text: 'Conversar', action: () => {}),
                          ButtonOffBottom(
                              text: 'Ver respostas de questionários',
                              action: () => {}),
                          ButtonStandardBottom(
                              text: 'Enviar Questionário',
                              action: () => {
                                    Navigator.pushNamed(
                                      context,
                                      "QuizDatePatient",
                                      arguments: {'patientId': patient},
                                    )
                                  })
                        ],
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
