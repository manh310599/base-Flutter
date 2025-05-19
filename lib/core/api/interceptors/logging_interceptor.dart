import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Interceptor for logging API requests and responses
class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
      _logger.d('Headers: ${_sanitizeHeaders(options.headers)}');
      _logger.d('Data: ${_sanitizeData(options.data)}');
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.i(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
      _logger.d('Response: ${response.data}');
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',

      );
      if (err.response != null) {
        _logger.d('Error Response: ${err.response?.data}');
      }
    }
    return handler.next(err);
  }

  // Sanitize sensitive data in headers (like tokens)
  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);
    
    if (sanitized.containsKey('Authorization')) {
      sanitized['Authorization'] = 'Bearer [REDACTED]';
    }
    
    return sanitized;
  }

  // Sanitize sensitive data in request body
  dynamic _sanitizeData(dynamic data) {
    if (data == null) return null;
    
    if (data is Map) {
      final sanitized = Map<String, dynamic>.from(data);
      
      // Redact sensitive fields
      final sensitiveFields = [
        'password',
        'pin',
        'token',
        'refreshToken',
        'cardNumber',
        'cvv',
        'ssn',
      ];
      
      for (final field in sensitiveFields) {
        if (sanitized.containsKey(field)) {
          sanitized[field] = '[REDACTED]';
        }
      }
      
      return sanitized;
    }
    
    return data;
  }
}
