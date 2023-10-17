import 'package:flutter/material.dart';

class QuizCheck extends StatefulWidget {
  final Map<String, dynamic> quest;
  final Function changeQuest;
  final Function(int id) removeQuiz;
  final int index;

  const QuizCheck({
    Key? key,
    required this.quest,
    required this.changeQuest,
    required this.removeQuiz,
    required this.index,
  }) : super(key: key);

  @override
  QuizCheckState createState() => QuizCheckState();
}

class QuizCheckState extends State<QuizCheck> {
  final TextEditingController titleController = TextEditingController();
  late List<String> options;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.quest['titulo'];
    options = List<String>.from(widget.quest['multiplas']);
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.only(left: 30, top: 20),
            child: Text("Pergunta ${widget.index + 1}"),
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
                    widget.quest['titulo'] = value;
                    widget.changeQuest(widget.quest);
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
                for (int i = 0; i < options.length; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/check.png'),
                          const SizedBox(width: 15),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: TextField(
                              onChanged: (value) {
                                options[i] = value;
                                widget.changeQuest(widget.quest);
                              },
                              controller:
                                  TextEditingController(text: options[i]),
                              decoration: InputDecoration(
                                hintText: "Digite o conteúdo do item",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF4F4F4F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          removeOption(i);
                        },
                        child: const Icon(
                          Icons.delete,
                          size: 40,
                          color: Color(0xFFFD4A4A),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: addOption,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_circle,
                        size: 24,
                        color: Color(0xFF595959),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Adicionar opção à lista",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xFF595959),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.removeQuiz(widget.quest['id']);
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

  void addOption() {
    setState(() {
      options.add("");
      widget.quest['multiplas'] = options;
      widget.changeQuest(widget.quest);
    });
  }

  void removeOption(int index) {
    setState(() {
      options.removeAt(index);
      widget.quest['multiplas'] = options;
      widget.changeQuest(widget.quest);
    });
  }
}
