import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:base_project2/core/auth/session_manager.dart';
import 'package:base_project2/core/api/api_result.dart';
import 'package:rxdart/rxdart.dart';

/// Authentication status enum.
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  authenticating,
  error,
}

/// Authentication manager for handling login, logout, and session management.
@singleton
class AuthManager {
  final SessionManager _sessionManager;
  
  /// Stream controller for the authentication status.
  final BehaviorSubject<AuthStatus> _authStatusController = BehaviorSubject<AuthStatus>();
  
  /// Current authentication status.
  AuthStatus _currentStatus = AuthStatus.initial;

  AuthManager(this._sessionManager) {
    _init();
  }

  /// Initializes the authentication manager.
  Future<void> _init() async {
    // Listen to session changes
    _sessionManager.sessionStream.listen((session) {
      if (session.isValid) {
        _updateAuthStatus(AuthStatus.authenticated);
      } else {
        _updateAuthStatus(AuthStatus.unauthenticated);
      }
    });

    // Set initial status based on current session
    if (_sessionManager.isSessionValid) {
      _updateAuthStatus(AuthStatus.authenticated);
    } else {
      _updateAuthStatus(AuthStatus.unauthenticated);
    }
  }

  /// Returns the current authentication status.
  AuthStatus get currentStatus => _currentStatus;

  /// Returns a stream of authentication statuses.
  Stream<AuthStatus> get authStatusStream => _authStatusController.stream;

  /// Returns true if the user is authenticated.
  bool get isAuthenticated => _currentStatus == AuthStatus.authenticated;

  /// Updates the authentication status.
  void _updateAuthStatus(AuthStatus status) {
    _currentStatus = status;
    _authStatusController.add(_currentStatus);
  }

  /// Logs in the user with the given credentials.
  /// 
  /// [loginCall] is a function that makes the login API call.
  /// Returns an [ApiResult] with the result of the login.
  Future<ApiResult<bool>> login<T>({
    required Future<T> Function() loginCall,
    required String Function(T) getAccessToken,
    required String Function(T) getRefreshToken,
    required String Function(T) getUserId,
    String? Function(T)? getUserRole,
    DateTime? Function(T)? getExpiryTime,
  }) async {
    try {
      _updateAuthStatus(AuthStatus.authenticating);

      final response = await loginCall();

      await _sessionManager.setSession(
        accessToken: getAccessToken(response),
        refreshToken: getRefreshToken(response),
        userId: getUserId(response),
        userRole: getUserRole?.call(response),
        expiryTime: getExpiryTime?.call(response),
      );

      _updateAuthStatus(AuthStatus.authenticated);
      return const ApiResult.success(true);
    } catch (e) {
      _updateAuthStatus(AuthStatus.error);
      return ApiResult.error(e.toString());
    }
  }

  /// Logs out the user.
  /// 
  /// [logoutCall] is an optional function that makes the logout API call.
  /// Returns an [ApiResult] with the result of the logout.
  Future<ApiResult<bool>> logout({
    Future<void> Function()? logoutCall,
  }) async {
    try {
      if (logoutCall != null) {
        await logoutCall();
      }

      await _sessionManager.clearSession();
      _updateAuthStatus(AuthStatus.unauthenticated);
      return const ApiResult.success(true);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  /// Refreshes the access token.
  /// 
  /// [refreshCall] is a function that makes the refresh token API call.
  /// Returns an [ApiResult] with the result of the refresh.
  Future<ApiResult<bool>> refreshToken<T>({
    required Future<T> Function(String refreshToken) refreshCall,
    required String Function(T) getAccessToken,
    DateTime? Function(T)? getExpiryTime,
  }) async {
    try {
      final refreshToken = _sessionManager.refreshToken;
      if (refreshToken == null) {
        return const ApiResult.error('No refresh token available');
      }

      final response = await refreshCall(refreshToken);

      await _sessionManager.updateAccessToken(
        accessToken: getAccessToken(response),
        expiryTime: getExpiryTime?.call(response),
      );

      return ApiResult.success(true);
    } catch (e) {
      return ApiResult.error(e.toString());
    }
  }

  /// Disposes the authentication manager.
  void dispose() {
    _authStatusController.close();
  }
}
