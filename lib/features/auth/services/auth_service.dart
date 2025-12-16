import 'package:petgo/core/constants/app_constants.dart';
import 'package:petgo/core/services/api_service.dart';
import 'package:petgo/features/auth/models/login_response.dart';
import 'package:petgo/models/customer_model.dart';

class AuthService {
  Future<LoginResponse> loginStore(String email, String password) async {
    return _login('${AppConstants.loginEndpoint}/store', email, password);
  }

  Future<LoginResponse> loginCustomer(String email, String password) {
    return _login('${AppConstants.loginEndpoint}/customer', email, password);
  }

  Future<LoginResponse> loginDelivery(String email, String password) {
    return _login('${AppConstants.loginEndpoint}/delivery', email, password);
  }

  Future<LoginResponse> loginVeterinary(String email, String password) {
    return _login('${AppConstants.loginEndpoint}/veterinary', email, password);
  }

  Future<LoginResponse> _login(
    String endpoint,
    String email,
    String password,
  ) async {
    final response = await ApiService.post(
      endpoint: endpoint,
      data: {'email': email, 'password': password},
    );

    if (response['success']) {
      return LoginResponse.fromJson(response['data']);
    }

    throw ServerException(response['message'] ?? 'Falha no login');
  }

  Future<void> sendVerificationCode(String emailOrPhone) async {
    final response = await ApiService.post(
      endpoint: AppConstants.sendCodeEndpoint,
      data: {'emailOrPhone': emailOrPhone},
    );

    if (response['success']) {
      throw ServerException(response['message'] ?? 'Erro ao enviar código');
    }
  }

  Future<CustomerModel?> verifyCode(String emailOrPhone, String code) async {
    final response = await ApiService.post(
      endpoint: AppConstants.verifyCodeEndpoint,
      data: {'email_or_phone': emailOrPhone, 'code': code},
    );

    if (response['success'] == true) {
      final data = response['data'];
      return CustomerModel.fromJson(data['customer']);
    }
    throw Exception(response['message'] ?? 'Falha ao verificar código');
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
