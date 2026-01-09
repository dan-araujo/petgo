class ApiEndpoints {
  static const String loginEndpoint = '/auth/login';
  static const String sendVerificationCodeEndpoint =
      '/auth/send-verification-code';
  static const String resendVerificationCodeEndpoint =
      '/auth/resend-verification-code';
  static const String verifyEmailCodeEndpoint = '/auth/verify-email';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String verifyResetCodeEndpoint = 'auth/verify-reset-code';
  static const String resetPasswordEndpoint = '/auth/reset-password';

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
