import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
  final List<Map<String, dynamic>> multiplas;

  const CheckBox({
    super.key,
    required this.multiplas,
  });

  @override
  CheckBoxState createState() => CheckBoxState();
}

class CheckBoxState extends State<CheckBox> {
  List<bool> checkedStates = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.multiplas.length; i++) {
      checkedStates.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 212,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < widget.multiplas.length; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  checkedStates[i] = !checkedStates[i];
                });
              },
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: checkedStates[i],
                    onChanged: (value) {
                      setState(() {
                        checkedStates[i] = value!;
                      });
                    },
                    activeColor: const Color(0xFFFF983D),
                  ),
                  Text(widget.multiplas[i]['texto']),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
