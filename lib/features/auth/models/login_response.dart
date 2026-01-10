class LoginResponse {
  final String accessToken;
  final UserData user;

  LoginResponse({required this.accessToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // A API atual retorna aninhado: data -> data -> { status, message, data: { access_token, user } }
    final outerData = json['data'] as Map<String, dynamic>? ?? {};
    final innerWrapper = outerData['data'] as Map<String, dynamic>? ?? {};
    final payload = innerWrapper['data'] as Map<String, dynamic>? ?? {};

    final accessToken = payload['access_token'] as String? ?? '';

    final userDataRaw = payload['user'] ?? {};
    final userData = userDataRaw is Map<String, dynamic>
        ? userDataRaw
        : (userDataRaw as Map).cast<String, dynamic>();

    return LoginResponse(
      accessToken: accessToken,
      user: UserData.fromJson(userData),
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
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'category': category};
  }
}
