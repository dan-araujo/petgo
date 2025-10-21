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
