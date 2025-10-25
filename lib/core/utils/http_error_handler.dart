String getFriendlyErrorMessage(int statusCode, [String? message]) {
  switch (statusCode) {
    case 400:
    case 422:
      return message ?? 'Verifique os dados informados.';
    case 401:
      return 'Sessão expirada. Faça login novamente.';
    case 403:
      return 'Você não tem permissão para realizar essa ação.';
    case 404:
      return 'Recurso não encontrado.';
    case 409:
      return message ?? 'Já existe um cadastro com esses dados.';
    case 408:
      return 'A requisição demorou demais. Tente novamente.';
    case 500:
      return 'Ocorreu um erro no servidor. Tente novamente mais tarde.';
    default:
      return message ??
          'Erro inesperado. Verique sua conexão e tente novamente.';
  }
}
