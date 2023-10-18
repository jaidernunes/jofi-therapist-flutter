import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jofi_therapist_flutter/src/components/speed_dial_add.dart';
import 'package:jofi_therapist_flutter/src/screens/edit_quiz.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';
import 'package:jofi_therapist_flutter/src/server/token.dart';

class TabQuiz extends StatefulWidget {
  const TabQuiz({super.key});

  @override
  TabQuizState createState() => TabQuizState();
}

class TabQuizState extends State<TabQuiz> {
  final api = Api();
  List<dynamic> listQuestion = [];
  String sentToPatient = "";

  @override
  void initState() {
    super.initState();
    listQuestionnaries();
  }

  void listQuestionnaries() async {
    try {
      final userId = await getUserId();
      final api = Api();

      final Response response = await api.makeRequest(
        "/questionnaires/therapist/$userId",
        method: 'GET',
      );

      if (response.statusCode == 200) {
        final questionnairesInfo = jsonDecode(response.body);
        setState(() {
          listQuestion = questionnairesInfo;
        });
      } else {
        throw Exception(
            'Failed to load questionnaires: ${response.reasonPhrase}');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Questionários"),
      //   backgroundColor: Colors.orange,
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.only(top: 5, bottom: 5),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listQuestion.length,
              itemBuilder: (context, index) {
                final item = listQuestion[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditQuiz(
                          routeParams: {
                            'id': item["id"],
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    // color: Colors.red,
                    padding: const EdgeInsets.all(15),
                    // margin: const EdgeInsets.only(
                    //   bottom: 37,
                    //   right: 10,
                    //   left: 10,
                    // ),
                    width: double.infinity,
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.grey),
                    //   borderRadius: BorderRadius.circular(8),
                    // ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item["titulo"],
                          style: const TextStyle(
                            color: Color(0xFF4F4F4F),
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          sentToPatient.isNotEmpty ? Icons.send : Icons.edit,
                          color: const Color(0xFFFF983D),
                          size: 45,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDialAdd(
        onPressed: () {
          Navigator.pushNamed(
            context,
            "AddQuiz",
          );
        },
        showSpeedDial: false,
      ),
    );
  }
}
