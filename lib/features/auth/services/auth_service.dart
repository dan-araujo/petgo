import 'package:petgo/core/api/api_endpoints.dart';
import 'package:petgo/core/errors/app_exceptions.dart';
import 'package:petgo/core/api/api_service.dart';
import 'package:petgo/features/auth/models/login_response.dart';

class AuthService {
  static Future<LoginResponse> loginStore(String email, String password) async {
    return _login(ApiEndpoints.loginByType('store'), email, password);
  }

  static Future<LoginResponse> loginCustomer(
    String email,
    String password,
  ) async {
    return _login(ApiEndpoints.loginByType('customer'), email, password);
  }

  static Future<LoginResponse> loginDelivery(
    String email,
    String password,
  ) async {
    return _login(ApiEndpoints.loginByType('delivery'), email, password);
  }

  static Future<LoginResponse> loginVeterinary(
    String email,
    String password,
  ) async {
    return _login(ApiEndpoints.loginByType('veterinary'), email, password);
  }

  static Future<LoginResponse> _login(
    String endpoint,
    String email,
    String password,
  ) async {
    final response = await ApiService.post(
      endpoint: endpoint,
      data: {'email': email, 'password': password},
    );

    // IMPORTANTE: Check status PRIMEIRO antes de tentar parsear LoginResponse
    // Porque o backend retorna status no root level
    final status = response['status'] as String?;

    // Handle pending verification status - deve vir ANTES de tentar usar token
    if (status == 'pending_code' || status == 'new_sent_code') {
      throw VerificationPendingException(
        email: (response['email'] as String?) ?? email,
        message: (response['message'] as String?) ?? 'Email não verificado',
      );
    }

    // Handle error responses
    if (response['success'] != true && status != 'success') {
      throw ServerException(response['message'] ?? 'Falha no login');
    }

    // Somente agora, que sabemos que é um login bem-sucedido, parsear LoginResponse
    return LoginResponse.fromJson(response);
  }
}
