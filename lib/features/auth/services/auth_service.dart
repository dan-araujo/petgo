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

    if (response['success'] != true) {
      throw ServerException(response['message'] ?? 'Falha no login');
    }

    final data = response['data'];

    if (data is Map<String, dynamic>) {
      final status = data['status'] as String?;

      if (status == 'new_sent_code' || status == 'pending_code') {
        throw VerificationPendingException(
          email: (data['email'] as String?) ?? email,
          message: (data['message'] as String?) ?? 'Email não verificado',
        );
      }
    }
    return LoginResponse.fromJson(response);
  }
}
