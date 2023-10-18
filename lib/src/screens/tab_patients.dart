import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/components/search.dart';
import 'package:jofi_therapist_flutter/src/components/speed_dial_patient.dart';
import 'package:jofi_therapist_flutter/src/screens/message_terapeuta.dart';
import 'package:jofi_therapist_flutter/src/screens/summary.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';
import 'package:jofi_therapist_flutter/src/server/token.dart';

class TabPatients extends StatefulWidget {
  const TabPatients({super.key});

  @override
  TabPatientsState createState() => TabPatientsState();
}

class TabPatientsState extends State<TabPatients> {
  final api = Api();
  List<dynamic> list = [];
  List<dynamic> filteredList = [];
  String therapistId = "";
  String expoPushToken = "";
  Object? notification;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listPatients();
  }

  Future<void> listPatients() async {
    try {
      final userId = await getUserId();

      setState(() {
        therapistId = userId!;
      });

      final response = await api.makeRequest(
        "/patients/therapist/$userId",
        method: 'GET',
      );

      if (response.statusCode == 200) {
        final patientsInfo = jsonDecode(response.body);

        setState(() {
          list = patientsInfo;
          filteredList = patientsInfo;
        });
      } else {
        throw Exception('Failed to fetch patients');
      }
    } catch (error) {
      print(error);
    }
  }

  void handleSearch(String value) {
    setState(() {
      searchController.text = value;
      filteredList = list
          .where((item) => item["nome"].toString().contains(value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const TopAppBar(title: "Pacientes"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Search(
              placeholder: "Busque um paciente",
              controller: searchController,
              onChanged: handleSearch,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];

                  print(item);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 29),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Summary(
                                  route: {
                                    'id': item["id"],
                                  },
                                ),
                              ),
                            );
                          },
                          child: Text(
                            item["nome"],
                            style: const TextStyle(
                              color: Color(0xFF4F4F4F),
                              fontSize: 20,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessageTerapeuta(
                                  routeParams: {
                                    'patientId': item["id"],
                                    'therapistId': therapistId,
                                  },
                                ),
                              ),
                            );
                          },
                          child: Image.asset("assets/images/chat.png"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SpeedDialPatient(
        onPress: () {
          Navigator.pushNamed(
            context,
            "AddPatient",
            arguments: {},
          );
        },
        showSpeedDial: false,
      ),
    );
  }
}
