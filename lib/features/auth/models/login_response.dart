class LoginResponse {
  final String accessToken;
  final UserData user;

  LoginResponse({required this.accessToken, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final authResponse = json['data'] as Map<String, dynamic>? ?? {};
    String accessToken = '';

    if (authResponse['access_token'] is String) {
      accessToken = authResponse['access_token'] as String;
    } else if (authResponse['data'] is Map<String, dynamic>) {
      final dataMap = authResponse['data'] as Map<String, dynamic>;
      accessToken = dataMap['access_token'] as String? ?? '';
    }

    final userDataRaw =
        authResponse['user'] ?? authResponse['data']?['user'] ?? {};
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
