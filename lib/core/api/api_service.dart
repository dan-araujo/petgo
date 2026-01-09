import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petgo/core/constants/app_constants.dart';
import 'package:petgo/core/errors/app_exceptions.dart';

class ApiService {
  static const String _baseUrl = AppConstants.baseUrl;
  static const Duration _timeout = AppConstants.connectionTimeout;
  static const Map<String, String> _defaultHeaders =
      AppConstants.defaultHeaders;

  static Future<Map<String, dynamic>> _request(
    String method,
    String endpoint, {
    Map<String, dynamic>? requestData,
    Map<String, String>? requestHeaders,
  }) async {
    final url = Uri.parse("$_baseUrl$endpoint");
    final headers = {..._defaultHeaders, ...?requestHeaders};

    try {
      final response = await _send(
        method,
        url,
        headers,
        requestData,
      ).timeout(_timeout);
      return _handleResponse(response);
    } on ServerException {
      rethrow;
    } on UnauthorizedException {
      rethrow;
    } on RateLimitException {
      rethrow;
    } on TimeoutException {
      throw ServerException('Servidor indisponível');
    } catch (_) {
      throw ServerException('Erro de conexão com o servidor');
    }
  }

  static Future<http.Response> _send(
    String method,
    Uri url,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) {
    switch (method.toUpperCase()) {
      case 'POST':
        return http.post(url, headers: headers, body: jsonEncode(body));
      case 'GET':
        return http.get(url, headers: headers);
      case 'PATCH':
        return http.patch(url, headers: headers, body: jsonEncode(body));
      case 'DELETE':
        return http.delete(url, headers: headers);
      default:
        throw Exception('Método HTTP não suportado: $method');
    }
  }

  static Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) => _request('POST', endpoint, requestData: data, requestHeaders: headers);

  static Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
  }) => _request('GET', endpoint, requestHeaders: headers);

  static Future<Map<String, dynamic>> patch({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) => _request('PATCH', endpoint, requestData: data, requestHeaders: headers);

  static Future<Map<String, dynamic>> delete({
    required String endpoint,
    Map<String, String>? headers,
  }) => _request('DELETE', endpoint, requestHeaders: headers);

  static Map<String, dynamic> _handleResponse(http.Response response) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw ServerException('Resposta inválida do servidor');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return {'success': true, 'data': decoded};
    }

    final errorMessage = decoded is Map<String, dynamic>
        ? decoded['message'] ?? 'Erro desconhecido'
        : 'Erro desconhecido';

    if (response.statusCode == 401) {
      throw UnauthorizedException(errorMessage);
    }

    if (response.statusCode == 429) {
      throw RateLimitException(errorMessage);
    }

    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ServerException(errorMessage);
    }

    throw ServerException(errorMessage);
  }
}
