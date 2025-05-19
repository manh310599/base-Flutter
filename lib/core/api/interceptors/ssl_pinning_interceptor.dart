import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for SSL certificate pinning
class SSLPinningInterceptor extends Interceptor {
  // List of SHA-256 hashes of the public key (SPKI) of your server certificates
  // You should have multiple backups in case of certificate rotation
  final List<String> _pinnedPublicKeyHashes = [
    // Example hashes - replace with your actual certificate hashes
    'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
    'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // In debug mode, you might want to disable SSL pinning
    if (kDebugMode) {
      handler.next(options);
      return;
    }

    // Add SSL pinning configuration to options
    options.extra['pinnedPublicKeyHashes'] = _pinnedPublicKeyHashes;

    // Continue with the request
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check if error is related to SSL verification
    if (err.type == DioExceptionType.badCertificate) {
      // Log the error and potentially report to analytics
      debugPrint('SSL Certificate Verification Failed: ${err.message}');

      // You can create a custom error to make it clear this was a security issue
      final securityError = DioException(
        requestOptions: err.requestOptions,
        error: 'SSL Certificate Verification Failed. Possible security breach attempt.',
        type: err.type,
      );

      // Use next with the error instead of reject
      handler.next(securityError);
      return;
    }

    // For other errors, continue with normal error handling
    handler.next(err);
  }
}
