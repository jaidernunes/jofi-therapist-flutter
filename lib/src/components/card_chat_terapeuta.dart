import 'package:flutter/material.dart';

class CardChatTerapeuta extends StatelessWidget {
  final String messageTerapeuta;
  final String hourMessageTerapeuta;

  const CardChatTerapeuta(
      {super.key,
      required this.messageTerapeuta,
      required this.hourMessageTerapeuta});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 212,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 16),
            child: Text(
              messageTerapeuta,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.visible,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5),
            child: Text(
              hourMessageTerapeuta,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
