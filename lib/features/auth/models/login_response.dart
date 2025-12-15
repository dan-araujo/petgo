class LoginResponse {
  final String accessToken;
  final UserData user;

  LoginResponse({
    required this.accessToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['data']['access_token'] ?? '', 
      user: UserData.fromJson(json['data']['user']),
      );
  }
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String category;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.category,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['data'] ?? '', 
      name: json['name'] ?? '', 
      email: json['email'] ?? '', 
      category: json['category'] ?? '',
      );
  }
}