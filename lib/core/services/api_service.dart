import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petgo/core/constants/app_constants.dart';

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
    int attempt = 0;
    const maxAttempts = 3;
    Duration delay = Duration(milliseconds: 500);

    while (attempt < maxAttempts) {
      try {
        final url = Uri.parse("$_baseUrl$endpoint");

        final customHeaders = {..._defaultHeaders, ...?requestHeaders};

        late http.Response response;

        switch (method.toUpperCase()) {
          case 'POST':
            response = await http
                .post(
                  url,
                  headers: customHeaders,
                  body: jsonEncode(requestData),
                )
                .timeout(_timeout);
            break;
          case 'GET':
            response = await http
                .get(url, headers: customHeaders)
                .timeout(_timeout);
            break;
          case 'PATCH':
            response = await http
                .patch(
                  url,
                  headers: customHeaders,
                  body: jsonEncode(requestData),
                )
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

        return _handleResponse(response);
      } catch (e) {
        attempt++;

        if (attempt >= maxAttempts) {
          return {
            'success': false,
            'message': 'Erro de conexão após $maxAttempts tentativas: $e',
          };
        }

        await Future.delayed(delay);
        delay = Duration(milliseconds: delay.inMilliseconds * 2);
      }
    }

    return {'success': false, 'message': 'Erro desconhecido'};
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
        return {'success': true, 'data': responseData};
      } else {
        return {
          'success': false,
          'statusCode': response.statusCode,
          'message': responseData['message'] ?? 'Erro inesperado',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Erro ao processar resposta: $e'};
    }
  }
}
