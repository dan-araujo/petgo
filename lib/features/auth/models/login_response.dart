class LoginResponse {
  final String accessToken;
  final UserData user;

  LoginResponse({required this.accessToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // ✅ Backend retorna: { success: true, data: { status, message, data: { access_token, user } } }
    final authResponse = json['data'] ?? {};
    final loginData = authResponse['data'] ?? {};

    print('📑 === PARSE LOGIN RESPONSE ===');
    print('JSON completo: $json');
    print('AuthResponse: $authResponse');
    print('LoginData: $loginData');

    return LoginResponse(
      accessToken: loginData['access_token'] ?? '',
      user: UserData.fromJson(loginData['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'user': user.toJson()};
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String? category;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.category,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'category': category};
  }
}
