import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/navigators/patient_screen.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';
import 'package:jofi_therapist_flutter/src/server/token.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({super.key});

  @override
  AddPatientState createState() => AddPatientState();
}

class AddPatientState extends State<AddPatient> {
  final api = Api();
  bool isVisible = false;
  String namePacient = "";
  String emailPacient = "";
  DateTime? date = DateTime.now();
  String telPacient = "";
  String profissionPacient = "";
  String descriptionPacient = "";
  String observPacient = "";
  String contactNamePacient = "";
  String contactRelacionPacient = "";
  String contactTelPacient = "";
  bool preventDuplication = false;

  Map<String, bool> isValid = {
    'namePacient': true,
    'emailPacient': true,
    'datePacient': true,
    'profissionPacient': true,
    'telPacient': true,
    'descriptionPacient': true,
    'observPacient': true,
    'contactNamePacient': true,
    'contactRelacionPacient': true,
    'contactTelPacient': true,
  };

  bool validateParam(String param) {
    return param.isNotEmpty;
  }

  void validateParams(bool contactIsValid) {
    setState(() {
      isValid = {
        'namePacient': validateParam(namePacient),
        'emailPacient': validateParam(emailPacient),
        'datePacient': date != null,
        'profissionPacient': validateParam(profissionPacient),
        'telPacient': validateParam(telPacient),
        'descriptionPacient': validateParam(descriptionPacient),
        'observPacient': validateParam(observPacient),
        'contactNamePacient': contactIsValid,
        'contactRelacionPacient': contactIsValid,
        'contactTelPacient': contactIsValid,
      };
    });
  }

  void handleSave() async {
    final contactIsValid = (contactNamePacient.isNotEmpty &&
            contactRelacionPacient.isNotEmpty &&
            contactTelPacient.isNotEmpty) ||
        (contactNamePacient.isEmpty &&
            contactRelacionPacient.isEmpty &&
            contactTelPacient.isEmpty);

    validateParams(contactIsValid);

    if (!contactIsValid) return;

    setState(() {
      preventDuplication = true;
    });

    try {
      final userId = await getUserId();

      final response = await api.makeRequest('/patient', method: 'POST', data: {
        'nome': namePacient,
        'email': emailPacient,
        'telefone': telPacient,
        'nascimento': date!.toIso8601String(),
        'profissao': profissionPacient,
        'descricao': descriptionPacient,
        'observacoes': observPacient,
        'terapeutaId': userId,
        if (contactIsValid)
          'contatoEmergencia': {
            'nome': contactNamePacient,
            'relacao': contactRelacionPacient,
            'telefone': contactTelPacient,
          },
      });

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PatientScreen(),
          ),
        );
      } else {
        setState(() {
          preventDuplication = false;
        });
        print('Failed to save patient: ${response.reasonPhrase}');
      }
    } catch (error) {
      setState(() {
        preventDuplication = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar paciente'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  onChanged: (value) => setState(() => namePacient = value),
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    errorText:
                        !isValid['namePacient']! ? 'Nome inválido' : null,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  onChanged: (value) => setState(() => emailPacient = value),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    errorText:
                        !isValid['emailPacient']! ? 'Email inválido' : null,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  onChanged: (value) => setState(() => telPacient = value),
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    errorText:
                        !isValid['telPacient']! ? 'Telefone inválido' : null,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: const Text('Data de nascimento'),
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: date ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2101),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: const Color(0xFF6200EE),
                          buttonTheme: const ButtonThemeData(
                            textTheme: ButtonTextTheme.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (selectedDate != null && selectedDate != date) {
                    setState(() {
                      date = selectedDate;
                    });
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 50.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      date != null
                          ? '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}'
                          : 'Data de nascimento',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  onChanged: (value) =>
                      setState(() => profissionPacient = value),
                  decoration: InputDecoration(
                    labelText: 'Profissão do paciente',
                    errorText: !isValid['profissionPacient']!
                        ? 'Profissão inválida'
                        : null,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  onChanged: (value) =>
                      setState(() => descriptionPacient = value),
                  decoration: InputDecoration(
                    labelText: 'Descrição do paciente',
                    errorText: !isValid['descriptionPacient']!
                        ? 'Descrição inválida'
                        : null,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  onChanged: (value) => setState(() => observPacient = value),
                  decoration: InputDecoration(
                    labelText: 'Observações sobre o paciente',
                    errorText: !isValid['observPacient']!
                        ? 'Observações inválidas'
                        : null,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Contatos de Emergência',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Icon(
                        isVisible
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
              if (isVisible) ...[
                TextField(
                  onChanged: (value) =>
                      setState(() => contactNamePacient = value),
                  decoration: InputDecoration(
                    labelText: 'Nome do contato',
                    errorText: !isValid['contactNamePacient']!
                        ? 'Nome inválido'
                        : null,
                  ),
                ),
                TextField(
                  onChanged: (value) =>
                      setState(() => contactRelacionPacient = value),
                  decoration: InputDecoration(
                    labelText: 'Relação com o contato',
                    errorText: !isValid['contactRelacionPacient']!
                        ? 'Relação inválida'
                        : null,
                  ),
                ),
                TextField(
                  onChanged: (value) =>
                      setState(() => contactTelPacient = value),
                  decoration: InputDecoration(
                    labelText: 'Telefone para contato',
                    errorText: !isValid['contactTelPacient']!
                        ? 'Telefone inválido'
                        : null,
                  ),
                ),
                if (!isValid['contactNamePacient']! &&
                    !isValid['contactRelacionPacient']! &&
                    !isValid['contactTelPacient']!)
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    child: Text(
                      'É necessário preencher todos os dados do contato para poder adicioná-lo.',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => handleSave(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: const Text('Cadastrar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
