import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const apiBaseUrl = "http://191.101.234.236:3001/api";

class Api {
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('@token');

    if (token == null) {
      return false;
    }

    try {
      final response = await makeRequest("/auth");
      if (response.statusCode == 200) {
        return true;
      } else {
        await prefs.remove('@token');
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Api._internal();

  Future<http.Response> makeRequest(
    String url, {
    Map<String, String>? headers,
    dynamic data,
    String method = 'GET',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('@token');

    print('API REQUEST =====> $method $url');
    print('Token: $token');

    if (token != null) {
      if (headers == null) {
        headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        headers['Authorization'] = 'Bearer $token';
        headers['Content-Type'] = 'application/json';
        headers['Accept'] = 'application/json';
      }
    } else {
      if (headers == null) {
        headers = {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };
      } else {
        headers['Content-Type'] = 'application/json';
        headers['Accept'] = 'application/json';
      }
    }

    http.Response response;
    print('$apiBaseUrl$url');

    if (method == 'GET') {
      response = await http.get(
        Uri.parse('$apiBaseUrl$url'),
        headers: headers,
      );
    } else if (method == 'POST') {
      final jsonData = jsonEncode(data);
      response = await http.post(
        Uri.parse('$apiBaseUrl$url'),
        headers: headers,
        body: jsonData,
      );
    } else {
      throw Exception('Unsupported HTTP method: $method');
    }

    print('API RESPONSE =====> ');
    print(response.body);

    if (response.statusCode == 200) {
      if (url.contains("login")) {
        final newToken = response.body;
        headers = {
          'Authorization': 'Bearer $newToken',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };
        await prefs.setString('@token', newToken);
      }
      return response;
    } else if (response.statusCode == 401) {
      await prefs.remove('@token');
      throw Exception('Unauthorized: ${response.reasonPhrase}');
    } else {
      throw Exception('Failed to make request: ${response.reasonPhrase}');
    }
  }
}
