class UserTypeMapper {
  static String toBackendEnum(String userType) {
    switch (userType.toLowerCase()) {
      case 'customer':
        return 'customer';
      case 'delivery':
        return 'delivery';
      case 'store':
        return 'store';
      case 'veterinary':
        return 'veterinary';
      default:
        throw ArgumentError('UserType inválido: $userType');
    }
  }
}
