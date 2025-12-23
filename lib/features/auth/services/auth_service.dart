import 'package:petgo/core/constants/app_constants.dart';
import 'package:petgo/core/services/api_service.dart';
import 'package:petgo/features/auth/models/login_response.dart';

class AuthService {
  Future<LoginResponse> loginStore(String email, String password) async {
    return _login(AppConstants.loginByType('store'), email, password);
  }

  Future<LoginResponse> loginCustomer(String email, String password) {
    return _login(AppConstants.loginByType('customer'), email, password);
  }

  Future<LoginResponse> loginDelivery(String email, String password) {
    return _login(AppConstants.loginByType('delivery'), email, password);
  }

  Future<LoginResponse> loginVeterinary(String email, String password) {
    return _login(AppConstants.loginByType('veterinary'), email, password);
  }

  static Future<LoginResponse> _login(
    String endpoint,
    String email,
    String password,
  ) async {
    try {
      final response = await ApiService.post(
        endpoint: endpoint,
        data: {'email': email, 'password': password},
      );

      if (response['success'] == true) {
        final data = response['data'];

        if (data['status'] == 'new_sent_code' ||
            data['status'] == 'pending_code') {
          throw VerificationPendingException(
            email: data['email'],
            message: data['message'],
          );
        }
        return LoginResponse.fromJson(response[data]);
      }

      throw ServerException(response['message'] ?? 'Falha no login');
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> sendVerificationCode(String email) async {
    try {
      final response = await ApiService.post(
        endpoint: AppConstants.sendCodeEndpoint,
        data: {'email': email},
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'message': response['message'],
          'email': response['data']['email'],
        };
      }

      throw ServerException(response['message'] ?? 'Erro ao enviar código');
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> verifyCode(
    String email,
    String code,
  ) async {
    try {
      final response = await ApiService.post(
        endpoint: AppConstants.verifyEmailEndpoint,
        data: {'email': email, 'code': code},
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'message': response['message'],
          'email': response['data']['email'],
        };
      }

      throw Exception(response['message'] ?? 'Falha ao verificar código');
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> resendVerificationCode(
    String email,
  ) async {
    try {
      final response = await ApiService.post(
        endpoint: AppConstants.resendCodeEndpoint,
        data: {'email': email},
      );

      if (response['success'] == true) {
        return {
          'success': true,
          'message': response['message'],
          'email': response['data']['email'],
        };
      }

      if (response['data']['status'] == 'error') {
        throw RateLimitException(response['data']['message']);
      }

      throw ServerException(response['message'] ?? 'Erro ao reenviar código');
    } catch (e) {
      rethrow;
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

class VerificationPendingException implements Exception {
  final String email;
  final String message;
  VerificationPendingException({required this.email, required this.message});

  @override
  String toString() => message;
}

class RateLimitException implements Exception {
  final String message;
  RateLimitException(this.message);

  @override
  String toString() => message;
}
