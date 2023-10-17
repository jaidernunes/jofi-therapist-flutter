import 'package:flutter/material.dart';

class SpeedDial extends StatelessWidget {
  final Function() openSpeed;
  final bool showSpeedDial;
  final Function(int) onPress;

  SpeedDial({
    super.key,
    required this.openSpeed,
    required this.showSpeedDial,
    required this.onPress,
  });

  final List<Map<String, dynamic>> _list = [
    {
      'id': 1,
      'label': 'Pergunta Múltipla Escolha',
      'icon': 'assets/images/checkbox.png',
    },
    {
      'id': 2,
      'label': 'Escala 0 a 10',
      'icon': 'assets/images/numeric.png',
    },
    {
      'id': 3,
      'label': 'Escala Likert',
      'icon': 'assets/images/likert.png',
    },
    {
      'id': 4,
      'label': 'Pergunta Descritiva',
      'icon': 'assets/images/Abc.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showSpeedDial)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var item in _list) _buildMenuItem(item),
            ],
          ),
        FloatingActionButton(
          onPressed: openSpeed,
          backgroundColor: const Color(0xFFFF983D),
          child: const Text(
            '+',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => onPress(item['id']),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 2),
              blurRadius: 3.84,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 220,
              child: Text(
                item['label'],
                style: const TextStyle(
                  color: Color(0xFF4F4F4F),
                ),
              ),
            ),
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFFF983D),
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 2),
                    blurRadius: 3.84,
                  ),
                ],
              ),
              child: Image.asset(item['icon']),
            ),
          ],
        ),
      ),
    );
  }
}
