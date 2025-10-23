class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;

  CustomerModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    role: json['role'],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
    "role": role,
  };
} 