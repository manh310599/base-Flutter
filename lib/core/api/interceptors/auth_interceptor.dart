import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../storage/secure_storage.dart';

/// Interceptor for handling authentication tokens
@injectable
class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final Dio _tokenDio;

  // Flag to prevent multiple token refresh requests
  bool _isRefreshing = false;

  // Queue of requests that are waiting for token refresh
  final _pendingRequests = <RequestOptions>[];

  AuthInterceptor(this._secureStorage)
      : _tokenDio = Dio();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token for authentication endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get access token from secure storage
    final token = await _secureStorage.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If the error is not 401 or it's an auth endpoint, just continue with the error
    if (err.response?.statusCode != 401 ||
        _isAuthEndpoint(err.requestOptions.path)) {
      return handler.next(err);
    }

    // Store the request that failed due to 401
    final requestOptions = err.requestOptions;

    // Clear the old token as it's invalid
    await _secureStorage.deleteAccessToken();

    // Try to refresh the token
    if (!_isRefreshing) {
      _isRefreshing = true;
      _pendingRequests.add(requestOptions);

      try {
        final refreshToken = await _secureStorage.getRefreshToken();

        if (refreshToken == null) {
          // No refresh token, reject all pending requests
          _rejectPendingRequests('No refresh token available');
          return handler.next(err);
        }

        // Call refresh token API
        final response = await _tokenDio.post(
          '/auth/refresh-token',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          // Save new tokens
          await _secureStorage.setAccessToken(response.data['accessToken']);
          await _secureStorage.setRefreshToken(response.data['refreshToken']);

          // Retry all pending requests with new token
          _retryPendingRequests();

          // Create a new request with the updated token
          final newRequest = await _retryRequest(requestOptions);
          return handler.resolve(newRequest);
        } else {
          // Refresh failed, reject all pending requests
          _rejectPendingRequests('Token refresh failed');
          return handler.next(err);
        }
      } catch (e) {
        // Error during refresh, reject all pending requests
        _rejectPendingRequests('Error during token refresh: $e');
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      // Already refreshing, add to pending queue
      _pendingRequests.add(requestOptions);
    }
  }

  // Helper to check if the endpoint is an auth endpoint
  bool _isAuthEndpoint(String path) {
    return path.contains('/auth/login') ||
           path.contains('/auth/refresh-token');
  }

  // Retry a request with the new token
  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final token = await _secureStorage.getAccessToken();

    // Clone the original request but update the token
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $token',
      },
    );

    return await Dio().request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // Retry all pending requests with new token
  void _retryPendingRequests() {
    for (final request in _pendingRequests) {
      _retryRequest(request);
    }
    _pendingRequests.clear();
  }

  // Reject all pending requests with an error
  void _rejectPendingRequests(String errorMessage) {
    for (final request in _pendingRequests) {
      // Create a new Dio instance to handle the rejected request
      final dio = Dio();
      final error = DioException(
        requestOptions: request,
        error: errorMessage,
        type: DioExceptionType.unknown,
      );

      // Use error callback instead of reject
      // dio.httpClientAdapter.onHttpClientCreate = (client) {
      //   dio.interceptors.errorLock.lock();
      //   dio.options.extra['_error'] = error;
      //   dio.interceptors.errorLock.unlock();
      //   return null;
      // };
    }
    _pendingRequests.clear();
  }
}
