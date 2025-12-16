class AppConstants {
  static const String baseUrl = "https://petgo-backend.onrender.com";
  static const String appName = 'PetGo!';
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static const Duration connectionTimeout = Duration(seconds: 30);

  static const String loginEndpoint = '/auth/login';
  static const String sendCodeEndpoint = '/auth/send-verification-code';
  static const String verifyCodeEndpoint = '/auth/verify-code';
}
