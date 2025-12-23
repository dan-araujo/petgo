class AppConstants {
  static const String baseUrl = "https://petgo-backend.onrender.com";
  static const String appName = 'PetGo!';
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static const Duration connectionTimeout = Duration(seconds: 60);
  static const String loginEndpoint = '/auth/login';
  static const String sendCodeEndpoint = '/auth/send-verification-code';
  static const String verifyEmailEndpoint = '/auth/verify-email';
  static const String resendCodeEndpoint = '/auth/resend-verification-code';

  static String registerByType(String userType) {
    switch (userType) {
      case 'customer':
        return '/customers/register';
      case 'store':
        return '/stores/register';
      case 'delivery':
        return '/delivery/register';
      case 'veterinary':
        return '/veterinaries/register';
      default:
        return '/$userType/register';
    }
  }

  static String loginByType(String userType) {
    return '$loginEndpoint/$userType';
  }
}
