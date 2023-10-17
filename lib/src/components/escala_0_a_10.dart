import 'package:flutter/material.dart';

class Escala0a10 extends StatefulWidget {
  final Map<String, dynamic> quest;
  final Function changeQuest;
  final Function removeQuiz;
  final int index;

  const Escala0a10(
      {super.key,
      required this.quest,
      required this.changeQuest,
      required this.removeQuiz,
      required this.index});

  @override
  _Escala0a10State createState() => _Escala0a10State();
}

class _Escala0a10State extends State<Escala0a10> {
  String titleQuiz = "";
  String option1 = "";
  String option2 = "";

  @override
  void initState() {
    super.initState();
    titleQuiz = widget.quest["titulo"];
    option1 = widget.quest["piorEscala"];
    option2 = widget.quest["melhorEscala"];
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController =
        TextEditingController(text: titleQuiz);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Text("Pergunta ${widget.index + 1}"),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller:
                      textEditingController, // Use TextEditingController
                  onChanged: (value) {
                    setState(() {
                      titleQuiz = value;
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: "Digite aqui o título da pergunta",
                  ),
                ),
                _buildCheckRow("0", option1),
                _buildCheckRow("10", option2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red, size: 40),
                      onPressed: () {
                        widget.removeQuiz(widget.quest["id"]);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckRow(String label, String value) {
    final TextEditingController textEditingController =
        TextEditingController(text: value);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 35,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4F4F4F)),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Text(label),
            ),
            const SizedBox(width: 15),
            SizedBox(
              width: 250,
              child: TextField(
                controller: textEditingController, // Use TextEditingController
                onChanged: (newValue) {
                  setState(() {
                    value = newValue;
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Digite o conteúdo do item",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
