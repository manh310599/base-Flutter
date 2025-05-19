import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:base_project2/core/storage/secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keys used for storing session data in secure storage.
class SessionKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String expiryTime = 'expiry_time';
  static const String isLoggedIn = 'is_logged_in';
}

/// Model representing a user session.
class UserSession {
  final String? accessToken;
  final String? refreshToken;
  final String? userId;
  final String? userRole;
  final DateTime? expiryTime;
  final bool isLoggedIn;

  UserSession({
    this.accessToken,
    this.refreshToken,
    this.userId,
    this.userRole,
    this.expiryTime,
    this.isLoggedIn = false,
  });

  /// Returns true if the session is valid (has an access token and is not expired).
  bool get isValid => accessToken != null && isLoggedIn && !isExpired;

  /// Returns true if the session is expired.
  bool get isExpired {
    if (expiryTime == null) return true;
    return DateTime.now().isAfter(expiryTime!);
  }

  /// Creates a copy of this session with the given fields replaced.
  UserSession copyWith({
    String? accessToken,
    String? refreshToken,
    String? userId,
    String? userRole,
    DateTime? expiryTime,
    bool? isLoggedIn,
  }) {
    return UserSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      expiryTime: expiryTime ?? this.expiryTime,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

/// Manages the user session throughout the application.
@singleton
class SessionManager {
  final SecureStorage _secureStorage;

  /// Stream controller for the user session.
  final BehaviorSubject<UserSession> _sessionController = BehaviorSubject<UserSession>();

  /// Current user session.
  UserSession _currentSession = UserSession();

  SessionManager(this._secureStorage) {
    _init();
  }

  /// Initializes the session manager by loading the session from secure storage.
  Future<void> _init() async {
    final accessToken = await _secureStorage.getAccessToken();
    final refreshToken = await _secureStorage.getRefreshToken();

    // Get user data from secure storage
    final userData = await _secureStorage.getUserData() ?? {};
    final userId = userData['userId'] as String?;
    final userRole = userData['userRole'] as String?;
    final expiryTimeStr = userData['expiryTime'] as String?;
    final isLoggedInStr = userData['isLoggedIn'] as String?;

    final expiryTime = expiryTimeStr != null
        ? DateTime.tryParse(expiryTimeStr)
        : null;
    final isLoggedIn = isLoggedInStr == 'true';

    _currentSession = UserSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      userRole: userRole,
      expiryTime: expiryTime,
      isLoggedIn: isLoggedIn,
    );

    _sessionController.add(_currentSession);
  }

  /// Returns the current user session.
  UserSession get currentSession => _currentSession;

  /// Returns a stream of user sessions.
  Stream<UserSession> get sessionStream => _sessionController.stream;

  /// Returns true if the user is logged in.
  bool get isLoggedIn => _currentSession.isLoggedIn;

  /// Returns true if the session is valid.
  bool get isSessionValid => _currentSession.isValid;

  /// Returns the access token.
  String? get accessToken => _currentSession.accessToken;

  /// Returns the refresh token.
  String? get refreshToken => _currentSession.refreshToken;

  /// Returns the user ID.
  String? get userId => _currentSession.userId;

  /// Returns the user role.
  String? get userRole => _currentSession.userRole;

  /// Sets the session data and saves it to secure storage.
  Future<void> setSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    String? userRole,
    DateTime? expiryTime,
  }) async {
    _currentSession = UserSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
      userRole: userRole,
      expiryTime: expiryTime,
      isLoggedIn: true,
    );

    await _saveSessionToStorage();
    _sessionController.add(_currentSession);
  }

  /// Updates the access token and expiry time.
  Future<void> updateAccessToken({
    required String accessToken,
    DateTime? expiryTime,
  }) async {
    _currentSession = _currentSession.copyWith(
      accessToken: accessToken,
      expiryTime: expiryTime,
    );

    await _secureStorage.setAccessToken(accessToken);

    // Update expiry time in user data
    if (expiryTime != null) {
      final userData = await _secureStorage.getUserData() ?? {};
      userData['expiryTime'] = expiryTime.toIso8601String();
      await _secureStorage.setUserData(userData);
    }

    _sessionController.add(_currentSession);
  }

  /// Clears the session data.
  Future<void> clearSession() async {
    _currentSession = UserSession();

    await _secureStorage.deleteAccessToken();
    await _secureStorage.deleteRefreshToken();

    // Clear user data or set isLoggedIn to false
    final userData = await _secureStorage.getUserData() ?? {};
    userData['isLoggedIn'] = 'false';
    await _secureStorage.setUserData(userData);

    _sessionController.add(_currentSession);
  }

  /// Saves the session data to secure storage.
  Future<void> _saveSessionToStorage() async {
    // Save tokens
    if (_currentSession.accessToken != null) {
      await _secureStorage.setAccessToken(_currentSession.accessToken!);
    }

    if (_currentSession.refreshToken != null) {
      await _secureStorage.setRefreshToken(_currentSession.refreshToken!);
    }

    // Save user data
    final userData = <String, dynamic>{
      'userId': _currentSession.userId,
      'userRole': _currentSession.userRole,
      'isLoggedIn': _currentSession.isLoggedIn.toString(),
    };

    if (_currentSession.expiryTime != null) {
      userData['expiryTime'] = _currentSession.expiryTime!.toIso8601String();
    }

    await _secureStorage.setUserData(userData);
  }

  /// Disposes the session manager.
  void dispose() {
    _sessionController.close();
  }
}
