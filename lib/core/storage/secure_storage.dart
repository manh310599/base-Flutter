import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../security/encryption_service.dart';

/// Service for securely storing sensitive data
@singleton
class SecureStorage {
  final FlutterSecureStorage _secureStorage;
  final EncryptionService _encryptionService;
  
  // Keys for stored values
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _pinKey = 'pin';
  static const String _biometricsEnabledKey = 'biometrics_enabled';
  static const String _lastActiveKey = 'last_active';

  SecureStorage(this._secureStorage, this._encryptionService);

  // Token management
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  Future<void> setAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  Future<void> setRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }

  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }

  // User data management with encryption
  Future<Map<String, dynamic>?> getUserData() async {
    final encryptedData = await _secureStorage.read(key: _userDataKey);
    if (encryptedData == null) return null;
    
    try {
      final decryptedJson = _encryptionService.decryptData(encryptedData);
      return Map<String, dynamic>.from(
        Uri.splitQueryString(decryptedJson).map(
          (key, value) => MapEntry(key, value),
        ),
      );
    } catch (e) {
      // If decryption fails, clear the corrupted data
      await _secureStorage.delete(key: _userDataKey);
      return null;
    }
  }

  Future<void> setUserData(Map<String, dynamic> userData) async {
    final queryParams = Uri(queryParameters: userData).query;
    final encryptedData = _encryptionService.encryptData(queryParams);
    await _secureStorage.write(key: _userDataKey, value: encryptedData);
  }

  // PIN management
  Future<String?> getPin() async {
    return await _secureStorage.read(key: _pinKey);
  }

  Future<void> setPin(String pin) async {
    final hashedPin = _encryptionService.encryptData(pin);
    await _secureStorage.write(key: _pinKey, value: hashedPin);
  }

  Future<bool> verifyPin(String enteredPin) async {
    final storedHashedPin = await _secureStorage.read(key: _pinKey);
    if (storedHashedPin == null) return false;
    
    final hashedEnteredPin = _encryptionService.encryptData(enteredPin);
    return hashedEnteredPin == storedHashedPin;
  }

  // Biometrics settings
  Future<bool> isBiometricsEnabled() async {
    final value = await _secureStorage.read(key: _biometricsEnabledKey);
    return value == 'true';
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _biometricsEnabledKey,
      value: enabled.toString(),
    );
  }

  // Session management
  Future<DateTime?> getLastActive() async {
    final timestamp = await _secureStorage.read(key: _lastActiveKey);
    if (timestamp == null) return null;
    
    return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  }

  Future<void> updateLastActive() async {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    await _secureStorage.write(key: _lastActiveKey, value: now);
  }

  // Clear all data (for logout)
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
