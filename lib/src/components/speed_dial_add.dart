import 'package:flutter/material.dart';

class SpeedDialAdd extends StatefulWidget {
  final Function() onPressed;
  final bool showSpeedDial;

  const SpeedDialAdd(
      {super.key, required this.onPressed, required this.showSpeedDial});

  @override
  SpeedDialAddState createState() => SpeedDialAddState();
}

class SpeedDialAddState extends State<SpeedDialAdd> {
  final List<Map<String, dynamic>> list = [
    {
      'id': 1,
      'label': 'Pergunta Múltipla Escolha',
      'icon': Icons.check_box,
    },
    {
      'id': 2,
      'label': 'Escala Likert',
      'icon': Icons.star,
    },
    {
      'id': 3,
      'label': 'Escala Likert',
      'icon': Icons.format_list_numbered,
    },
    {
      'id': 4,
      'label': 'Pergunta Descritiva',
      'icon': Icons.text_fields,
    },
  ];
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.showSpeedDial)
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: list.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      // Handle button press for each item in the list.
                    },
                    backgroundColor: const Color(0xFFFF983D),
                    child: Icon(
                      item['icon'],
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: widget.onPressed,
            backgroundColor: const Color(0xFFFF983D),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
