import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

Future<void> registerForPushNotificationsAsync() async {
  try {
    final token = await _firebaseMessaging.getToken();

    if (token != null) {
      // Token received, you can send it to your server or save it locally.
      print('Push Notification Token: $token');
    } else {
      print('Failed to get push token for push notification!');
    }
  } catch (e) {
    print('Error registering for push notifications: $e');
  }
}

Future<void> sendPushNotification(
    String fcmToken, String title, String description) async {
  try {
    final message = {
      'to': fcmToken,
      'notification': {
        'title': title,
        'body': description,
      },
      'data': {
        'terapeutaId': 'dawawddawdwa',
        'someData': 'goes here',
      },
    };

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=YOUR_SERVER_KEY', // Replace with your server key
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Push notification sent successfully');
    } else {
      print('Failed to send push notification');
    }
  } catch (e) {
    print('Error sending push notification: $e');
  }
}
