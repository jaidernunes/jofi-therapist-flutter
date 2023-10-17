import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jofi_therapist_flutter/src/components/gap.dart';
import 'package:jofi_therapist_flutter/src/server/api.dart';
import 'package:intl/intl.dart';

class MessageTerapeuta extends StatefulWidget {
  final Map<String, dynamic> routeParams;

  const MessageTerapeuta({
    super.key,
    required this.routeParams,
  });

  @override
  MessageTerapeutaState createState() => MessageTerapeutaState();
}

class MessageTerapeutaState extends State<MessageTerapeuta> {
  final api = Api();
  final ScrollController scrollChat = ScrollController();
  final TextEditingController textController = TextEditingController();
  List<Map<String, dynamic>> list = [];
  List<Map<String, dynamic>> listChat = [];
  String message = "";
  String? pushToken;

  @override
  void initState() {
    super.initState();
    listChatMessages();
  }

  void listChatMessages() async {
    try {
      final patientId = widget.routeParams['patientId'];
      final therapistId = widget.routeParams['therapistId'];

      // Fetch patient info
      final patientInfoResponse = await api.makeRequest('patient/$patientId');
      final patientInfoData = jsonDecode(patientInfoResponse.body);

      if (patientInfoData['pushToken'] != null) {
        setState(() {
          pushToken = patientInfoData['pushToken'];
        });
      }

      // Fetch chat messages
      final messagesResponse = await api.makeRequest("listchat",
          data: {
            'pacienteId': patientId,
            'terapeutaId': therapistId,
          },
          method: 'POST');

      final messagesData = json.decode(messagesResponse.body);

      final messagesFormatted = messagesData.map((message) {
        return {
          'id': message['id'],
          'identify': message['pacienteMensagem'] != null ? 1 : 0,
          'text': message['pacienteMensagem'] ?? message['terapeutaMensagem'],
          'createdAt': message['createdAt'],
        };
      }).toList();

      setState(() {
        list = messagesFormatted;
      });
    } catch (error) {
      print(error);
    }
  }

  void sendMessage() async {
    if (message.isEmpty) return;

    try {
      final patientId = widget.routeParams['patientId'];
      final therapistId = widget.routeParams['therapistId'];

      await api.makeRequest("/chat",
          data: {
            'terapeutaMensagem': message,
            'pacienteId': patientId,
            'terapeutaId': therapistId,
          },
          method: 'POST');

      listChatMessages();

      setState(() {
        message = "";
      });

      /* if (pushToken != null) {
      sendPushNotification(
        pushToken,
        "Nova mensagem",
        "Seu terapeuta mandou uma nova mensagem!",
      );
    } */
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MessageTerapeuta'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                  bottom: 16), // Add margin to the Container
              child: Text(
                'Paciente: ${widget.routeParams['nameUser']}',
                style: const TextStyle(
                  color: Color(0xFF4F4F4F),
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  bottom: 50), // Add margin to the Container
              child: const Text(
                'Última resposta: 29/09/2022 às 10:35',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollChat,
                itemCount: listChat.length,
                itemBuilder: (context, section) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        DateFormat('dd/MM/yyyy')
                            .format(listChat[section]['title']),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF595959),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 219,
              color: const Color(0xFFF0F2F5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: textController,
                    onChanged: (value) {
                      setState(() {
                        message = value;
                      });
                    },
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF4F4F4F),
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Mensagem',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(),
                      GestureDetector(
                        onTap: sendMessage,
                        child: Container(
                          width: 147,
                          height: 46,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF983D),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                  'assets/images/sendIcon.png',
                                ),
                              ),
                              SizedBox(width: 17),
                              Text(
                                'Enviar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4F4F4F),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
