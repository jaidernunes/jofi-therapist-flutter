import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/themes/app_theme.dart';

class EmergencyContactCard extends StatelessWidget {
  final Map<String, dynamic> patient;

  const EmergencyContactCard({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.standardOrange, width: 3),
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.standardLightOrange,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            patient['ContatoEmergencia']?['nome'] ?? 'Não informado',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            patient['ContatoEmergencia']?['relacao'] ?? 'Não informado',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            patient['ContatoEmergencia']?['telefone'] ?? 'Não informado',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
