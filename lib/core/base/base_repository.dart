import 'package:base_project2/core/api/api_result.dart';
import 'package:base_project2/core/network/connectivity_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Base repository class for all repositories in the application.
/// Provides common functionality for API calls and error handling.
abstract class BaseRepository {
  final ConnectivityService _connectivityService;

  BaseRepository(this._connectivityService);

  /// Executes an API call and handles errors.
  /// 
  /// [apiCall] is the function that makes the API call.
  /// Returns an [ApiResult] with the result of the API call.
  Future<ApiResult<T>> safeApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      // Check for internet connection
      if (!await _connectivityService.isOnline()) {
        return ApiResult.noInternet();
      }

      // Execute the API call
      final response = await apiCall();
      return ApiResult.success(response);
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  /// Handles DioException and converts it to an ApiResult.
  ApiResult<T> _handleDioError<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiResult.error('Connection timeout. Please try again later.');
      case DioExceptionType.badCertificate:
        return ApiResult.error('Invalid SSL certificate.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = _extractErrorMessage(e.response) ?? 'Bad response from server.';
        return ApiResult.error(message, statusCode: statusCode);
      case DioExceptionType.cancel:
        return ApiResult.error('Request was cancelled.');
      case DioExceptionType.connectionError:
        return ApiResult.noInternet();
      case DioExceptionType.unknown:
      default:
        return ApiResult.error(e.message ?? 'Unknown error occurred.');
    }
  }

  /// Extracts error message from the response.
  String? _extractErrorMessage(Response? response) {
    if (response == null) return null;
    
    try {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ?? data['error'] ?? 'Unknown error occurred.';
      }
      return data.toString();
    } catch (e) {
      return null;
    }
  }
}
