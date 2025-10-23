bool isValidEmail(String email) {
  final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$');
  return regex.hasMatch(email);
}

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'O nome é obrigatório';
  }
  final parts = value.trim().split(' ');
  if (parts.length < 2) {
    return 'Informe o nome completo';
  }
  if (value.length < 3) {
    return 'Nome muito curto';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'O telefone é obrigatório';
  }
  final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
  if (cleaned.length < 10 || cleaned.length > 11) {
    return 'Telefone inválido';
  }
  return null;
}

bool isValidCNPJ(String cnpj) {
  cnpj = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

  if (cnpj.length != 14) return false;
  if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) return false;

  List<int> numbers = cnpj.split('').map(int.parse).toList();
  int calcCheckDigit(List<int> base, List<int> factors) {
    int sum = 0;
    for (int i = 0; i < factors.length; i++) {
      sum += base[i] * factors[i];
    }
    int mod = sum % 11;
    return (mod < 2) ? 0 : 11 - mod;
  }

  final firstDigit = calcCheckDigit(numbers, [
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ]);
  if (numbers[12] != firstDigit) return false;

  final secondDigit = calcCheckDigit(numbers, [
    6,
    5,
    4,
    3,
    2,
    9,
    8,
    7,
    6,
    5,
    4,
    3,
    2,
  ]);
  if (numbers[13] != secondDigit) return false;

  return true;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'A senha é obrigatória';
  } else if (value.length < 6) {
    return 'Senha deve ter no mínimo 6 caracteres';
  }
  return null; // válida
}

String? validateCategory(String? value) {
  if (value == null || value.isEmpty) {
    return 'Selecione uma categoria';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'O e-mail é obrigatório';
  } else if (!isValidEmail(value)) {
    return 'E-mail inválido';
  }
  return null;
}

bool isValidCPF(String cpf) {
  // Remover tudo o que não for número
  cpf = cpf.replaceAll(RegExp(r'\D'), '');

  if (cpf.length != 11) return false;
  // Checar se todos os números são iguais
  if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;

  // Validar os digitos verificadores
  List<int> numbers = cpf.split('').map(int.parse).toList();
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += numbers[i] * (10 - i);
  }

  int firstDigit = (sum * 10 % 11) % 10;
  if (numbers[9] != firstDigit) return false;

  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += numbers[i] * (11 - i);
  }

  int secondDigit = (sum * 10 % 11) % 10;
  if (numbers[10] != secondDigit) return false;

  return true;
}
