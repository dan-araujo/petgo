import 'package:petgo/models/customer_model.dart';

Future<void> sendVerificationCode(String emailOrPhone) async {
  // futuramente vai enviar o código OTP (por e-mail ou SMS)
}

Future<CustomerModel?> verifyCode(String emailOrPhone, String code) async {
  return null;

  // futuramente valida o código e retorna o usuário autenticado
}