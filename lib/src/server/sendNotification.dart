import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendPushNotification(String expoPushToken, String title, String description) async {
  try {
    final message = {
      'to': expoPushToken,
      'sound': 'default',
      'title': title,
      'body': description,
      'data': {
        'terapeutaId': 'dawawddawdwa',
        'someData': 'goes here',
      },
    };

    final response = await http.post(
      Uri.parse('https://exp.host/--/api/v2/push/send'),
      headers: {
        'Accept': 'application/json',
        'Accept-encoding': 'gzip, deflate',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Push notification sent successfully');
    } else {
      print('Failed to send push notification');
    }
  } catch (error) {
    print('Error sending push notification: $error');
  }
}
