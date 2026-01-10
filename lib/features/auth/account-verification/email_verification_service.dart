import 'package:petgo/core/errors/app_exceptions.dart';
import 'package:petgo/core/api/api_service.dart';
import 'package:petgo/core/mappers/user_type_mapper.dart';
import '../../../core/api/api_endpoints.dart';

class EmailVerificationService {
  static Future<void> sendVerificationCode(String email) async {
    final response = await ApiService.post(
      endpoint: ApiEndpoints.sendVerificationCodeEndpoint,
      data: {'email': email},
    );

    // Check if response was successful
    if (response['success'] != true) {
      // Check if there's a rate limit issue
      final message = response['message'] as String? ?? 'Erro ao enviar código';
      if (message.contains('Aguarde')) {
        throw RateLimitException(message);
      }
      throw ServerException(message);
    }
  }

  static Future<void> resendVerificationCode({
    required String email,
    required String userType,
  }) async {
    final response = await ApiService.post(
      endpoint: ApiEndpoints.resendVerificationCodeEndpoint,
      data: {'email': email, 'userType': UserTypeMapper.toBackendEnum(userType)},
    );

    // Check if response was successful
    if (response['success'] != true) {
      // Check if there's a rate limit issue
      final message = response['message'] as String? ?? 'Erro ao reenviar código';
      if (message.contains('Aguarde')) {
        throw RateLimitException(message);
      }
      throw ServerException(message);
    }
  }

  static Future<void> verifyEmailCode({
    required String email,
    required String code,
    required String userType,
  }) async {
    final response = await ApiService.post(
      endpoint: ApiEndpoints.verifyEmailCodeEndpoint,
      data: {'email': email, 'code': code, 'userType': UserTypeMapper.toBackendEnum(userType)},
    );

    // Check if response was successful
    if (response['success'] != true) {
      throw ServerException(response['message'] ?? 'Código inválido ou expirado');
    }
  }
}
