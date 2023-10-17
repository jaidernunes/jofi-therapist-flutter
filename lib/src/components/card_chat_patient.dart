import 'package:flutter/material.dart';

class CardChatPatient extends StatelessWidget {
  final String messagePatient;
  final String hourMessagePatient;

  const CardChatPatient(
      {super.key,
      required this.messagePatient,
      required this.hourMessagePatient});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 212,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2C8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 16),
            child: Text(
              messagePatient,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.visible,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5),
            child: Text(
              hourMessagePatient,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
