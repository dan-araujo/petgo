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
      return {'success': false, 'message': 'Erro de conexão com o servidor'};
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
    try {
      final responseData = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'success': responseData['success'] ?? true, ...responseData};
      }

      return {
        'success': false,
        'statusCode': response.statusCode,
        'message':
            responseData['message'] ??
            responseData['error'] ??
            'Erro inesperado',
      };
    } catch (_) {
      return {'success': false, 'message': 'Resposta inválida do servidor'};
    }
  }
}
