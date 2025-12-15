import 'dart:convert';
import 'package:petgo/features/auth/models/login_response.dart';
import 'package:petgo/models/customer_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<LoginResponse> loginStore(String email, String password) {
    return _performLogin('store', email, password);
  }

  Future<LoginResponse> loginCustomer(String email, String password) {
    return _performLogin('customer', email, password);
  }

  Future<LoginResponse> loginDelivery(String email, String password) {
    return _performLogin('delivery', email, password);
  }

  Future<LoginResponse> loginVeterinary(String email, String password) {
    return _performLogin('veterinary', email, password);
  }

  Future<LoginResponse> _performLogin(
    String type,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/$type'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      return _handleLoginResponse(response);
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch(e) {
      throw ServerException('Erro de conexão: $e');
    }
  }

  LoginResponse _handleLoginResponse(http.Response response) {
    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return LoginResponse.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException('Email ou senha incorretos');
    } else {
      throw ServerException(
        'Erro ao conectar ao servidor: ${response.statusCode}',
      );
    }
  }
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => message;
}

Future<void> sendVerificationCode(String emailOrPhone) async {
  // futuramente vai enviar o código OTP (por e-mail ou SMS)
}

Future<CustomerModel?> verifyCode(String emailOrPhone, String code) async {
  return null;

  // futuramente valida o código e retorna o usuário autenticado
}
