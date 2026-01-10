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

    // Check if response has pending_code status at ROOT level (backend returns it there, not in data)
    final status = response['status'] as String?;
    
    if (status == 'pending_code' || status == 'new_sent_code') {
      throw VerificationPendingException(
        email: (response['email'] as String?) ?? email,
        message: (response['message'] as String?) ?? 'Email não verificado',
      );
    }

    // If response indicates success, parse LoginResponse
    final isSuccess = response['success'] == true;
    if (!isSuccess) {
      throw ServerException(response['message'] ?? 'Falha no login');
    }

    return LoginResponse.fromJson(response);
  }
}
