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

    if (response['success'] != true) {
      throw ServerException(response['message'] ?? 'Erro ao enviar código');
    }
  }

  static Future<void> resendVerificationCode({
    required String email,
    required String userType,
  }) async {
    final response = await ApiService.post(
      endpoint: ApiEndpoints.resendVerificationCodeEndpoint,
      data: {'email': email, 'type': UserTypeMapper.toBackendEnum(userType)},
    );

    if (response['success'] != true) {
      throw ServerException(response['message'] ?? 'Erro ao reenviar código');
    }
  }

  static Future<void> verifyEmailCode({
    required String email,
    required String code,
    required String userType,
  }) async {
    final response = await ApiService.post(
      endpoint: ApiEndpoints.verifyEmailCodeEndpoint,
      data: {'email': email, 'code': code, 'type': UserTypeMapper.toBackendEnum(userType)},
    );

    if (response['success'] != true) {
      throw ServerException(response['message'] ?? 'Código inválido');
    }
  }
}
