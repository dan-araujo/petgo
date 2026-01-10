import 'package:petgo/core/errors/app_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String _tokenKey = 'access_token';

  static Future<void> saveToken(String token) async {
    // Validação crítica: nunca permite token vazio
    if (token.isEmpty) {
      throw ServerException('Token inválido ou vazio');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveUser(
    String userId,
    String userName,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('\$_userKey:id', userId);
    await prefs.setString('\$_userKey:name', userName);
    await prefs.setString('\$_userKey:email', email);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove('\$_userKey:id');
    await prefs.remove('\$_userKey:name');
    await prefs.remove('\$_userKey:email');
  }
}
