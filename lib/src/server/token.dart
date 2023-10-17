import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('@token');

  if (token != null) {
    final Map<String, dynamic> tokenInfo = Jwt.parseJwt(token);
    final userId = tokenInfo['id'];
    return userId.toString();
  } else {
    return null;
  }
}
