import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/themes/app_theme.dart';

class EmergencyContact {
  final String nome;
  final String relacao;
  final String telefone;

  EmergencyContact({required this.nome, required this.relacao, required this.telefone});
}

class EmergencyContactCard extends StatelessWidget {
  final List<EmergencyContact> contacts;

  const EmergencyContactCard({Key? key, required this.contacts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.standardOrange, width: 3),
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.standardLightOrange,
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contacts[index].nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    contacts[index].relacao,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    contacts[index].telefone,
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
                    onPressed: () => {},
                    icon: Image.asset("assets/images/edit.png"),
                    iconSize: 45,
                  ),
                  IconButton(
                    onPressed: () => {},
                    icon: Image.asset("assets/images/icon_trash.png"),
                    iconSize: 45,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
