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

    // Check if response was successful
    final isSuccess = response['success'] == true;
    
    // Get status from response (backend returns it at root level)
    final status = response['status'] as String?;

    // Handle pending verification status BEFORE trying to use token
    if (status == 'pending_code' || status == 'new_sent_code') {
      throw VerificationPendingException(
        email: (response['email'] as String?) ?? email,
        message: (response['message'] as String?) ?? 'Email não verificado',
      );
    }

    // If not successful and no pending_code status, throw error
    if (!isSuccess) {
      throw ServerException(response['message'] ?? 'Falha no login');
    }

    // Only now, if we're sure it's a successful login, parse LoginResponse
    return LoginResponse.fromJson(response);
  }
}
