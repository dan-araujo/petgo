class AppConstants {
  static const String baseUrl = "https://petgo-backend.onrender.com";
  static const String appName = 'PetGo!';
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static const Duration connectionTimeout = Duration(seconds: 60);
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String sendCodeEndpoint = '$baseUrl/auth/send-verification-code';
  static const String verifyEmailEndpoint = '$baseUrl/auth/verify-email';
  static const String resendCodeEndpoint = '$baseUrl/auth/resend-verification-code';

  static String registerByType(String userType) {
    return '$baseUrl/$userType/register';
  }

  static String loginByType(String userType) {
    return '$loginEndpoint/$userType';
  }
}
