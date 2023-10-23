import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/components/button_standard_bottom.dart';
import 'package:jofi_therapist_flutter/src/components/textform_input_container.dart';
import 'package:jofi_therapist_flutter/src/navigators/patient_screen.dart';
import 'package:jofi_therapist_flutter/src/navigators/top_appbar.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';
import 'package:jofi_therapist_flutter/src/server/token.dart';
import 'package:jofi_therapist_flutter/themes/app_theme.dart';

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
  List emergencyContacts = [
    {
      'nome': 'João',
      'relacao': 'Pai',
      'telefone': '(11) 99999-9999',
    },
    {
      'nome': 'Maria',
      'relacao': 'Mãe',
      'telefone': '(11) 99999-9999',
    },
  ];

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
        // 'contactNamePacient': contactIsValid,
        // 'contactRelacionPacient': contactIsValid,
        // 'contactTelPacient': contactIsValid,
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
        // if (contactIsValid) //TODO: move this to add contact
        //   'contatoEmergencia': [{
        //     'nome': contactNamePacient,
        //     'relacao': contactRelacionPacient,
        //     'telefone': contactTelPacient,
        //   },],
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
      appBar: const TopAppBar(
        title: "Cadastrar paciente",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormInputContainer(
                child: TextFormField(
                  onChanged: (value) => setState(() => namePacient = value),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Nome do paciente',
                    hintStyle: AppTheme.inputHintTextStyle,
                    border: InputBorder.none,
                    errorText:
                        !isValid['namePacient']! ? 'Nome inválido' : null,
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   padding: const EdgeInsets.only(left: 15),
              //   alignment: Alignment.centerLeft,
              //   height: 46,
              //   decoration: BoxDecoration(
              //     border: Border.all(
              //       color: const Color(0xFF4F4F4F),
              //       width: 1.0,
              //     ),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: TextFormField(
              //     onChanged: (value) => setState(() => namePacient = value),
              //     style: const TextStyle(
              //       fontFamily: 'Inter',
              //       fontWeight: FontWeight.w400,
              //     ),
              //     decoration: InputDecoration(
              //       hintText: 'Nome do paciente',
              //       border: InputBorder.none,
              //       errorText:
              //           !isValid['namePacient']! ? 'Nome inválido' : null,
              //     ),
              //   ),
              // ),

              TextFormInputContainer(
                child: TextField(
                  onChanged: (value) => setState(() => emailPacient = value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'E-mail',
                    hintStyle: AppTheme.inputHintTextStyle,
                    errorText:
                        !isValid['emailPacient']! ? 'Email inválido' : null,
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   child: TextField(
              //     onChanged: (value) => setState(() => emailPacient = value),
              //     decoration: InputDecoration(
              //       labelText: 'E-mail',
              //       errorText:
              //           !isValid['emailPacient']! ? 'Email inválido' : null,
              //     ),
              //   ),
              // ),
              TextFormInputContainer(
                child: TextField(
                  onChanged: (value) => setState(() => telPacient = value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Telefone celular',
                    hintStyle: AppTheme.inputHintTextStyle,
                    errorText:
                        !isValid['telPacient']! ? 'Telefone inválido' : null,
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   child: TextField(
              //     onChanged: (value) => setState(() => telPacient = value),
              //     decoration: InputDecoration(
              //       labelText: 'Telefone',
              //       errorText:
              //           !isValid['telPacient']! ? 'Telefone inválido' : null,
              //     ),
              //   ),
              // ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data de nascimento',
                          style: AppTheme.inputHintTextStyle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          date != null
                              ? '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}'
                              : 'Data de nascimento',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                          // textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: date ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: AppTheme.standardOrange ,
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
                      icon: Image.asset("assets/images/edit.png"),
                      iconSize: 45,
                    ),
                  ],
                ),
              ),

              // Container(
              //   margin: const EdgeInsets.only(top: 15),
              //   child: const Text('Data de nascimento'),
              // ),
              // GestureDetector(
              //   onTap: () async {
              //     DateTime? selectedDate = await showDatePicker(
              //       context: context,
              //       initialDate: date ?? DateTime.now(),
              //       firstDate: DateTime(1900),
              //       lastDate: DateTime(2101),
              //       builder: (BuildContext context, Widget? child) {
              //         return Theme(
              //           data: ThemeData.light().copyWith(
              //             primaryColor: const Color(0xFF6200EE),
              //             buttonTheme: const ButtonThemeData(
              //               textTheme: ButtonTextTheme.primary,
              //             ),
              //           ),
              //           child: child!,
              //         );
              //       },
              //     );
              //     if (selectedDate != null && selectedDate != date) {
              //       setState(() {
              //         date = selectedDate;
              //       });
              //     }
              //   },
              //   child: Container(
              //     margin: const EdgeInsets.only(top: 10),
              //     height: 50.0,
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //         color: Colors.grey,
              //       ),
              //       borderRadius: BorderRadius.circular(5.0),
              //     ),
              //     child: Center(
              //       child: Text(
              //         date != null
              //             ? '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}'
              //             : 'Data de nascimento',
              //         style: const TextStyle(
              //           fontSize: 16.0,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              TextFormInputContainer(
                child: TextField(
                  onChanged: (value) =>
                      setState(() => profissionPacient = value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Profissão',
                    hintStyle: AppTheme.inputHintTextStyle,
                    errorText: !isValid['profissionPacient']!
                        ? 'Profissão inválida'
                        : null,
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   child: TextField(
              //     onChanged: (value) =>
              //         setState(() => profissionPacient = value),
              //     decoration: InputDecoration(
              //       labelText: 'Profissão do paciente',
              //       errorText: !isValid['profissionPacient']!
              //           ? 'Profissão inválida'
              //           : null,
              //     ),
              //   ),
              // ),

              TextFormInputContainer(
                child: TextField(
                  onChanged: (value) =>
                      setState(() => descriptionPacient = value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Descrição',
                    hintStyle: AppTheme.inputHintTextStyle,
                    errorText: !isValid['descriptionPacient']!
                        ? 'Descrição inválida'
                        : null,
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   child: TextField(
              //     onChanged: (value) =>
              //         setState(() => descriptionPacient = value),
              //     decoration: InputDecoration(
              //       labelText: 'Descrição do paciente',
              //       errorText: !isValid['descriptionPacient']!
              //           ? 'Descrição inválida'
              //           : null,
              //     ),
              //   ),
              // ),

              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF4F4F4F),
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    onChanged: (value) => setState(() => observPacient = value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Observações',
                      hintStyle: AppTheme.inputHintTextStyle,
                      errorText: !isValid['observPacient']!
                          ? 'Observações inválidas'
                          : null,
                    ),
                    minLines: 5,
                    maxLines: 50,
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(top: 10),
              //   child: TextField(
              //     onChanged: (value) => setState(() => observPacient = value),
              //     decoration: InputDecoration(
              //       labelText: 'Observações sobre o paciente',
              //       errorText: !isValid['observPacient']!
              //           ? 'Observações inválidas'
              //           : null,
              //     ),
              //     minLines: 5,
              //     maxLines: 50,
              //   ),
              // ),

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

                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: const BoxDecoration(
                          color: AppTheme.standardOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),

                      // Icon(
                      //   isVisible
                      //       ? Icons.keyboard_arrow_up
                      //       : Icons.keyboard_arrow_down,
                      //   size: 24.0,
                      // ),

                    ],
                  ),
                ),
              ),

              if (emergencyContacts.isNotEmpty)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: emergencyContacts.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppTheme.standardOrange, width: 3),
                        borderRadius: BorderRadius.circular(8),
                        color: AppTheme.standardLightOrange,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                emergencyContacts[index]['nome'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                emergencyContacts[index]['relacao'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                emergencyContacts[index]['telefone'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () => {
                                  setState(() {
                                    contactNamePacient = emergencyContacts[index]['nome'];
                                    contactRelacionPacient = emergencyContacts[index]['relacao'];
                                    contactTelPacient = emergencyContacts[index]['telefone'];
                                    emergencyContacts.removeAt(index);
                                    isVisible = true;
                                  })
                                },
                                icon: Image.asset("assets/images/edit.png"),
                                iconSize: 45,
                              ),
                              IconButton(
                                onPressed: () => {
                                  setState(() {
                                    emergencyContacts.removeAt(index);
                                  })
                                },
                                icon: Image.asset("assets/images/icon_trash.png"),
                                iconSize: 45,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),


              if (isVisible) ...[

                // TextField(
                //   onChanged: (value) =>
                //       setState(() => contactNamePacient = value),
                //   decoration: InputDecoration(
                //     labelText: 'Nome do contato',
                //     errorText: !isValid['contactNamePacient']!
                //         ? 'Nome inválido'
                //         : null,
                //   ),
                // ),
                // TextField(
                //   onChanged: (value) =>
                //       setState(() => contactRelacionPacient = value),
                //   decoration: InputDecoration(
                //     labelText: 'Relação com o contato',
                //     errorText: !isValid['contactRelacionPacient']!
                //         ? 'Relação inválida'
                //         : null,
                //   ),
                // ),
                // TextField(
                //   onChanged: (value) =>
                //       setState(() => contactTelPacient = value),
                //   decoration: InputDecoration(
                //     labelText: 'Telefone para contato',
                //     errorText: !isValid['contactTelPacient']!
                //         ? 'Telefone inválido'
                //         : null,
                //   ),
                // ),

                TextFormInputContainer(
                  child: TextField(
                    onChanged: (value) =>
                        setState(() => contactNamePacient = value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nome',
                      hintStyle: AppTheme.inputHintTextStyle,
                      errorText: !isValid['contactNamePacient']!
                          ? 'Nome inválido'
                          : null,
                    ),
                  ),
                ),
                TextFormInputContainer(
                  child: TextField(
                    onChanged: (value) =>
                        setState(() => contactRelacionPacient = value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Relacionamento',
                      hintStyle: AppTheme.inputHintTextStyle,
                      errorText: !isValid['contactRelacionPacient']!
                          ? 'Relação inválida'
                          : null,
                    ),
                  ),
                ),
                TextFormInputContainer(
                  child: TextField(
                    onChanged: (value) =>
                        setState(() => contactTelPacient = value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Telefone',
                      hintStyle: AppTheme.inputHintTextStyle,
                      errorText: !isValid['contactTelPacient']!
                          ? 'Telefone inválido'
                          : null,
                    ),
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
              if (isVisible)
                ButtonStandardBottom(
                  text: 'Adicionar Contato de Emergência',
                  action: () {
                    setState(() {
                      emergencyContacts.add({
                        'nome': contactNamePacient,
                        'relacao': contactRelacionPacient,
                        'telefone': contactTelPacient,
                      });
                      isVisible = false;

                    });
                  },
                ),

              // Container(
              //   margin: const EdgeInsets.only(top: 30),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       ElevatedButton(
              //         onPressed: () => handleSave(),
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.orange,
              //           disabledBackgroundColor: Colors.grey,
              //         ),
              //         child: const Text('Cadastrar'),
              //       ),
              //     ],
              //   ),
              // ),

              SizedBox(height: 35),
              ButtonStandardBottom(
                text: 'Cadastrar',
                action: () => handleSave(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
