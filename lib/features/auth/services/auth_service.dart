import 'package:petgo/models/user_model.dart';

Future<void> sendVerificationCode(String emailOrPhone) async {
  // futuramente vai enviar o código OTP (por e-mail ou SMS)
}

Future<UserModel?> verifyCode(String emailOrPhone, String code) async {
  // futuramente valida o código e retorna o usuário autenticado
}