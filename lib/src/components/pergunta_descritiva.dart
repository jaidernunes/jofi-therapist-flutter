import 'package:flutter/material.dart';

class PerguntaDescritiva extends StatelessWidget {
  final Map<String, dynamic> quest;
  final Function changeQuest;
  final Function(int id) removeQuiz;
  final int index;

  const PerguntaDescritiva({
    super.key,
    required this.quest,
    required this.changeQuest,
    required this.removeQuiz,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: quest["titulo"]);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x00fff6ee),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              top: 20,
            ),
            child: Text("Pergunta ${index + 1}"),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  onChanged: (value) {
                    quest["titulo"] = value;
                    changeQuest(quest);
                  },
                  decoration: InputDecoration(
                    hintText: "Digite aqui o título da pergunta",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF4F4F4F),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        removeQuiz(quest["id"]);
                      },
                      child: const Icon(
                        Icons.delete,
                        size: 40,
                        color: Color(0xFFFD4A4A),
                      ),
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
}
