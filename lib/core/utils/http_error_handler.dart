String getFriendlyErrorMessage(int statusCode, dynamic messageData) {
  String extractMessage(dynamic messageData) {
    if (messageData is List) {
      return messageData.join('\n');
    } else if (messageData is String) {
      return messageData;
    } else if (messageData is Map && messageData.containsKey('message')) {
      return extractMessage(messageData['message']);
    } else {
      return 'Erro inesperado. Tente novamente.';
    }
  }

  final message = extractMessage(messageData);

  switch (statusCode) {
    case 400:
    case 422:
      return message.isNotEmpty ? message : 'Verifique os dados informados.';
    case 401:
      return 'Sessão expirada. Faça login novamente.';
    case 403:
      return 'Você não tem permissão para realizar essa ação.';
    case 404:
      return 'Recurso não encontrado.';
    case 408:
      return 'A requisição demorou demais. Tente novamente.';
    case 409:
      return message.isNotEmpty
          ? message
          : 'Já existe um cadastro com esses dados.';
    case 500:
      return 'Ocorreu um erro no servidor. Tente novamente mais tarde.';
    default:
      return message.isNotEmpty
          ? message
          : 'Erro inesperado. Verique sua conexão e tente novamente.';
  }
}
