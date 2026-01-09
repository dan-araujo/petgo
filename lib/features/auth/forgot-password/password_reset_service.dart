import 'package:petgo/core/api/api_endpoints.dart';
import 'package:petgo/core/api/api_service.dart';
import 'package:petgo/core/mappers/user_type_mapper.dart';

class PasswordResetService {
  static Future<void> requestResetCode({
    required String email,
    required String userType,
  }) async {
    await ApiService.post(
      endpoint: ApiEndpoints.forgotPasswordEndpoint,
      data: {
        'email': email,
        'userType': UserTypeMapper.toBackendEnum(userType),
      },
    );
  }

  static Future<String> verifyResetCode({
    required String email,
    required String code,
    required String userType,
  }) async {
    final response = await ApiService.post(
      endpoint: ApiEndpoints.verifyResetCodeEndpoint,
      data: {
        'email': email,
        'code': code,
        'userType': UserTypeMapper.toBackendEnum(userType),
      },
    );

    return response['reset_token'];
  }

  static Future<void> resetPassword({
    required String resetToken,
    required String newPassword,
    required String confirmPassword,
    required String userType,
  }) async {
    final response = await ApiService.post(
      endpoint: ApiEndpoints.resetPasswordEndpoint,
      data: {
        'resetToken': resetToken,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
        'userType': UserTypeMapper.toBackendEnum(userType),
      },
    );

    if (response['success'] != true) {
      throw Exception(response['message']);
    }
  }
}
