import 'package:flutter/foundation.dart';
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

    if (kDebugMode) {
      print('🔍 AuthService._login() response: $response');
    }

    // Aqui o backend está aninhando data duas vezes: data.data.status
    final outerData = response['data'] as Map<String, dynamic>?;
    final innerData = outerData?['data'] as Map<String, dynamic>?;
    final status = innerData?['status'] as String?;

    if (kDebugMode) {
      print('🔍 Checking status in inner data: $status');
    }

    if (status == 'pending_code' || status == 'new_sent_code') {
      if (kDebugMode) {
        print(
          '🔍 Status is pending_code or new_sent_code, throwing VerificationPendingException',
        );
      }
      throw VerificationPendingException(
        email: (innerData?['email'] as String?) ?? email,
        message: (innerData?['message'] as String?) ?? 'Email não verificado',
      );
    }

    final isSuccess = response['success'] == true;
    if (kDebugMode) {
      print('🔍 isSuccess: $isSuccess');
    }

    if (!isSuccess) {
      if (kDebugMode) {
        print('🔍 Response is not success, throwing ServerException');
      }
      throw ServerException(response['message'] ?? 'Falha no login');
    }

    if (kDebugMode) {
      print('🔍 Parsing LoginResponse...');
    }
    return LoginResponse.fromJson(response);
  }
}
