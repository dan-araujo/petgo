class LoginResponse {
  final String accessToken;
  final UserData user;

  LoginResponse({required this.accessToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    print('📑 === PARSE LOGIN RESPONSE ===');
    print('JSON completo: $json');
    print('JSON keys: ${json.keys.toList()}');
    
    // ✅ Backend retorna: { success: true, data: { access_token, user: {...} } }
    final authResponse = json['data'] ?? {};
    print('AuthResponse: $authResponse');
    print('AuthResponse type: ${authResponse.runtimeType}');
    print('AuthResponse keys: ${authResponse is Map ? (authResponse as Map).keys.toList() : "N/A"}');

    // ✅ Token pode estar direto em 'access_token' ou dentro de 'data'
    final accessToken = 
        authResponse['access_token'] as String? ?? 
        (authResponse['data'] is Map ? authResponse['data']['access_token'] : null) ?? 
        '';
    
    final userData = authResponse['user'] ?? authResponse['data']?['user'] ?? {};
    
    print('AccessToken: ${accessToken.substring(0, 20)}...');
    print('UserData: $userData');
    print('---');

    return LoginResponse(
      accessToken: accessToken,
      user: UserData.fromJson(userData is Map ? userData : {}),
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
    print('👤 === PARSE USER DATA ===');
    print('UserData JSON: $json');
    print('UserData keys: ${json.keys.toList()}');
    
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
