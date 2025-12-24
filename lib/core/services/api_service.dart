import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petgo/core/constants/app_constants.dart';

// 🔴 Exceção específica para erro de servidor
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

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
    final customHeaders = {..._defaultHeaders, ...?requestHeaders};

    late http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http
              .post(url, headers: customHeaders, body: jsonEncode(requestData))
              .timeout(_timeout);
          break;
        case 'GET':
          response = await http
              .get(url, headers: customHeaders)
              .timeout(_timeout);
          break;
        case 'PATCH':
          response = await http
              .patch(url, headers: customHeaders, body: jsonEncode(requestData))
              .timeout(_timeout);
          break;
        case 'DELETE':
          response = await http
              .delete(url, headers: customHeaders)
              .timeout(_timeout);
          break;
        default:
          throw Exception('Método HTTP não suportado: $method');
      }

      // 🔥 AGORA ERRO NÃO VIRA MAP
      return _handleResponse(response);
    } catch (e) {
      // 🔴 ERRO DE CONEXÃO REAL → EXCEÇÃO
      throw ServerException('Erro de conexão: $e');
    }
  }

  static Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) =>
      _request('POST', endpoint, requestData: data, requestHeaders: headers);

  static Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
  }) =>
      _request('GET', endpoint, requestHeaders: headers);

  static Future<Map<String, dynamic>> patch({
    required String endpoint,
    required Map<String, dynamic> data,
    Map<String, String>? headers,
  }) =>
      _request('PATCH', endpoint, requestData: data, requestHeaders: headers);

  static Future<Map<String, dynamic>> delete({
    required String endpoint,
    Map<String, String>? headers,
  }) =>
      _request('DELETE', endpoint, requestHeaders: headers);

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);

    // ✅ HTTP OK
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // 🔴 SE BACKEND DIZ success=false → EXCEÇÃO
      if (responseData is Map &&
          responseData.containsKey('success') &&
          responseData['success'] == false) {
        throw ServerException(
          responseData['message'] ?? 'Erro de verificação',
        );
      }

      return responseData;
    }

    // 🔴 HTTP ERRO → EXCEÇÃO
    throw ServerException(
      responseData['message'] ?? 'Erro inesperado (${response.statusCode})',
    );
  }
}
