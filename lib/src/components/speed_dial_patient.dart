import 'package:flutter/material.dart';

class SpeedDialPatient extends StatelessWidget {
  final Function() onPress;
  final bool showSpeedDial;

  SpeedDialPatient({
    super.key,
    required this.onPress,
    required this.showSpeedDial,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showSpeedDial)
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var item in _menuItems)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildMenuItem(item),
                  ),
              ],
            ),
          ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: onPress,
            backgroundColor: const Color(0xFFFF983D),
            child: Image.asset('assets/images/adicionarpaciente.png'),
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> _menuItems = [
    {
      'id': 1,
      'label': 'Pergunta Múltipla Escolha',
      'icon': 'assets/checkbox.png',
    },
    {
      'id': 2,
      'label': 'Escala Likert',
      'icon': 'assets/likert.png',
    },
    {
      'id': 3,
      'label': 'Escala Likert',
      'icon': 'assets/numeric.png',
    },
    {
      'id': 4,
      'label': 'Pergunta Descritiva',
      'icon': 'assets/Abc.png',
    },
  ];

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return FloatingActionButton(
      onPressed: () {
        // Handle button press for each item in the list.
      },
      backgroundColor: const Color(0xFFFF983D),
      child: Image.asset(item['icon']),
    );
  }
}
