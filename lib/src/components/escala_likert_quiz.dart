import 'package:flutter/material.dart';

class EscalaLikertQuiz extends StatefulWidget {
  final Map<String, dynamic> quest;
  final Function changeQuest;
  final Function removeQuiz;
  final int index;

  const EscalaLikertQuiz({
    super.key,
    required this.quest,
    required this.changeQuest,
    required this.removeQuiz,
    required this.index,
  });

  @override
  _EscalaLikertQuizState createState() => _EscalaLikertQuizState();
}

class _EscalaLikertQuizState extends State<EscalaLikertQuiz> {
  late TextEditingController titleQuizController;
  late TextEditingController option1Controller;
  late TextEditingController option2Controller;

  @override
  void initState() {
    super.initState();
    titleQuizController = TextEditingController(text: widget.quest["titulo"]);
    option1Controller = TextEditingController(text: widget.quest["piorEscala"]);
    option2Controller =
        TextEditingController(text: widget.quest["melhorEscala"]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x00fff6ee),
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
                  controller: titleQuizController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    hintText: "Digite aqui o título da pergunta",
                  ),
                ),
                _buildCheckRow("1", option1Controller),
                _buildCheckRow("5", option2Controller),
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

  Widget _buildCheckRow(String label, TextEditingController controller) {
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
                controller: controller,
                onChanged: (newValue) {
                  setState(() {});
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
