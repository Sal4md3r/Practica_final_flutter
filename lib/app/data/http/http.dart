import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../../domain/either.dart';
import '../../domain/enums.dart';

part 'failure.dart';
part 'logs.dart';
part 'network_exception.dart';
part 'parse_response_body.dart';

class Http {
  Http({
    required Client client,
    required String baseUrl,
    required String apiKey,
  })  : _client = client,
        _baseUrl = baseUrl,
        _apiKey = apiKey;

  final Client _client;
  final String _baseUrl;
  final String _apiKey;

  Future<Either<HttpFailure, R>> request<R>(
    String path, {
    required R Function(dynamic responseBody) onSuccess,
    RequestType method = RequestType.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParams = const {},
    bool useApiKey = true,
    Map<String, dynamic> body = const {},
  }) async {
    Map<String, dynamic> logs = {};
    StackTrace? stackTrace;
    try {
      if (useApiKey) {
        queryParams = {
          ...queryParams,
          'api_key': _apiKey,
        };
      }

      Uri url = Uri.parse(
        path.startsWith('http') ? path : '$_baseUrl$path',
      );

      if (queryParams.isNotEmpty) {
        url = url.replace(
          queryParameters: queryParams,
        );
      }

      headers = {
        'Content-Type': 'application/json',
        ...headers,
      };

      final bodyString = jsonEncode(body);

      logs = {
        'url': url.toString(),
        'method': method.name,
        'body': body.toString(),
      };

      late final Response response;

      switch (method) {
        case RequestType.get:
          response = await _client.get(
            url,
          );
          break;
        case RequestType.post:
          response = await _client.post(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case RequestType.patch:
          response = await _client.patch(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case RequestType.put:
          response = await _client.put(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
        case RequestType.delete:
          response = await _client.delete(
            url,
            headers: headers,
            body: bodyString,
          );
          break;
      }

      final statusCode = response.statusCode;
      final responseBody = _parseResponseBody(response.body);

      logs = {
        ...logs,
        'Start time': DateTime.now().toString(),
        'Status Code': response.statusCode,
        'Response Body': _parseResponseBody(response.body),
      };

      if (statusCode >= 200 && statusCode < 300) {
        return Either.right(onSuccess(responseBody));
      }

      return Either.left(
        HttpFailure(statusCode: statusCode),
      );
    } catch (e, s) {
      stackTrace = s;
      logs = {
        ...logs,
        'Exception type': e.runtimeType,
      };

      if (e is ClientException || e is SocketException) {
        logs = {...logs, 'Exception type': 'Network Exception'};
        return Either.left(
          HttpFailure(exception: NetworkException()),
        );
      }

      return Either.left(
        HttpFailure(exception: e),
      );
    } finally {
      _printLogs(logs, stackTrace);
    }
  }
}
