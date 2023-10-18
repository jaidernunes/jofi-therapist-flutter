import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/components/buttons_quiz.dart';
import 'package:jofi_therapist_flutter/src/navigators/top_appbar.dart';
import 'package:jofi_therapist_flutter/src/screens/quiz_grafic.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Grafic2 extends StatelessWidget {
  final Map<String, dynamic> routeParams;

  Grafic2({
    super.key,
    required this.routeParams,
  });

  final List<Map<String, dynamic>> data = [
    {"mother": "01/02", "earnings": 1},
    {"mother": "02/02", "earnings": 2},
    {"mother": "03/02", "earnings": 5},
    {"mother": "04/02", "earnings": 7},
    {"mother": "05/02", "earnings": 2},
    {"mother": "06/02", "earnings": 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: "Grafic2"),

      // appBar: AppBar(
      //   title: const Text('Grafic2'),
      // ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                'Paciente: ${routeParams['nameUser']}',
                style: const TextStyle(
                  color: Color(0xFF4F4F4F),
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: const Text(
                'Última resposta: 29/09/2022 às 10:35',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                height: 300, // Adjust the height according to your design
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(),
                  series: <ChartSeries>[
                    AreaSeries<Map<String, dynamic>, String>(
                      dataSource: data,
                      xValueMapper: (Map<String, dynamic> data, _) =>
                          data['mother'] as String,
                      yValueMapper: (Map<String, dynamic> data, _) =>
                          data['earnings'] as num,
                      borderColor: const Color(0xFFFF983D),
                      color: const Color(0xFFFF983D),
                      borderWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
            ButtonsQuiz(
              actionLeft: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Grafic2(
                      routeParams: const {
                        'nameUser': 'Name of User for Grafic2',
                        'title': 'Title for Grafic2',
                      },
                    ),
                  ),
                );
              },
              actionRight: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizGrafic(
                      routeParams: {
                        'nameUser': 'Name of User for QuizGrafic',
                        'title': 'Title for QuizGrafic',
                      },
                      patientId:
                          'Patient ID for QuizGrafic', // Pass the patient ID here
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
