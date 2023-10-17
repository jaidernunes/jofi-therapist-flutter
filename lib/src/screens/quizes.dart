import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/components/radio_buttons.dart';

class DescritivaWidget extends StatelessWidget {
  final String id;
  final String titulo;
  final String resposta;

  const DescritivaWidget({
    super.key,
    required this.id,
    required this.titulo,
    required this.resposta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/iconedissertativa.png",
              ),
              Text(
                titulo,
                style: const TextStyle(
                  color: Color(0xFF4F4F4F),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "Resposta: $resposta",
              style: const TextStyle(
                color: Color(0xFF4F4F4F),
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EscalaNormalWidget extends StatelessWidget {
  final String id;
  final String titulo;
  final String escala;

  const EscalaNormalWidget({
    super.key,
    required this.id,
    required this.titulo,
    required this.escala,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/images/iconeescala010.png"),
              Text(
                "$titulo (0 a 10)",
                style: const TextStyle(
                  color: Color(0xFF4F4F4F),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "Resposta: $escala",
              style: const TextStyle(
                color: Color(0xFF4F4F4F),
                fontSize: 16,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EscalaLikertWidget extends StatelessWidget {
  final String id;
  final String melhorEscala;
  final String piorEscala;
  final String titulo;
  final String escala;

  const EscalaLikertWidget({
    super.key,
    required this.id,
    required this.melhorEscala,
    required this.piorEscala,
    required this.titulo,
    required this.escala,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/iconelikert.png",
              ),
              Text(
                titulo,
                style: const TextStyle(
                  color: Color(0xFF4F4F4F),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          RadioButtons(
            check: escala,
            melhorEscala: melhorEscala,
            piorEscala: piorEscala,
          ),
        ],
      ),
    );
  }
}
