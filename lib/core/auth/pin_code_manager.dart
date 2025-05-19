import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:base_project2/core/storage/secure_storage.dart';
import 'package:base_project2/core/security/encryption_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keys used for storing PIN code data in secure storage.
class PinCodeKeys {
  static const String pinCode = 'pin_code';
  static const String pinCodeAttempts = 'pin_code_attempts';
  static const String pinCodeLockTime = 'pin_code_lock_time';
  static const String pinCodeEnabled = 'pin_code_enabled';
}

/// PIN code verification result enum.
enum PinVerificationResult {
  success,
  failure,
  locked,
  notSet,
}

/// PIN code manager for handling PIN code verification and management.
@singleton
class PinCodeManager {
  final SecureStorage _secureStorage;
  final EncryptionService _encryptionService;

  /// Maximum number of PIN code attempts before locking.
  final int maxAttempts;

  /// Lock duration in minutes.
  final int lockDurationMinutes;

  PinCodeManager(
    this._secureStorage,
    this._encryptionService, {
    this.maxAttempts = 3,
    this.lockDurationMinutes = 30,
  });

  /// Returns true if PIN code is enabled.
  Future<bool> isPinCodeEnabled() async {
    final userData = await _secureStorage.getUserData() ?? {};
    return userData['pinCodeEnabled'] == 'true';
  }

  /// Returns true if PIN code is set.
  Future<bool> isPinCodeSet() async {
    final pin = await _secureStorage.getPin();
    return pin != null && pin.isNotEmpty;
  }

  /// Sets the PIN code.
  Future<bool> setPinCode(String pinCode) async {
    try {
      // Set the PIN
      await _secureStorage.setPin(pinCode);

      // Update user data
      final userData = await _secureStorage.getUserData() ?? {};
      userData['pinCodeEnabled'] = 'true';
      userData['pinCodeAttempts'] = '0';
      await _secureStorage.setUserData(userData);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Changes the PIN code.
  Future<bool> changePinCode(String oldPinCode, String newPinCode) async {
    final result = await verifyPinCode(oldPinCode);
    if (result == PinVerificationResult.success) {
      return setPinCode(newPinCode);
    }
    return false;
  }

  /// Disables the PIN code.
  Future<bool> disablePinCode(String pinCode) async {
    final result = await verifyPinCode(pinCode);
    if (result == PinVerificationResult.success) {
      final userData = await _secureStorage.getUserData() ?? {};
      userData['pinCodeEnabled'] = 'false';
      await _secureStorage.setUserData(userData);
      return true;
    }
    return false;
  }

  /// Verifies the PIN code.
  Future<PinVerificationResult> verifyPinCode(String pinCode) async {
    // Check if PIN code is set
    if (!await isPinCodeSet()) {
      return PinVerificationResult.notSet;
    }

    // Check if PIN code is locked
    if (await isPinCodeLocked()) {
      return PinVerificationResult.locked;
    }

    // Verify PIN code
    final isValid = await _secureStorage.verifyPin(pinCode);

    if (isValid) {
      // Reset attempts on successful verification
      final userData = await _secureStorage.getUserData() ?? {};
      userData['pinCodeAttempts'] = '0';
      await _secureStorage.setUserData(userData);
      return PinVerificationResult.success;
    } else {
      // Increment attempts on failed verification
      await _incrementAttempts();
      return PinVerificationResult.failure;
    }
  }

  /// Returns true if PIN code is locked.
  Future<bool> isPinCodeLocked() async {
    final userData = await _secureStorage.getUserData() ?? {};
    final lockTimeStr = userData['pinCodeLockTime'] as String?;
    if (lockTimeStr == null) {
      return false;
    }

    final lockTime = DateTime.tryParse(lockTimeStr);
    if (lockTime == null) {
      return false;
    }

    final now = DateTime.now();
    final lockDuration = Duration(minutes: lockDurationMinutes);
    final unlockTime = lockTime.add(lockDuration);

    return now.isBefore(unlockTime);
  }

  /// Returns the remaining lock time in seconds.
  Future<int> getRemainingLockTime() async {
    final userData = await _secureStorage.getUserData() ?? {};
    final lockTimeStr = userData['pinCodeLockTime'] as String?;
    if (lockTimeStr == null) {
      return 0;
    }

    final lockTime = DateTime.tryParse(lockTimeStr);
    if (lockTime == null) {
      return 0;
    }

    final now = DateTime.now();
    final lockDuration = Duration(minutes: lockDurationMinutes);
    final unlockTime = lockTime.add(lockDuration);

    if (now.isAfter(unlockTime)) {
      return 0;
    }

    return unlockTime.difference(now).inSeconds;
  }

  /// Increments the number of failed attempts.
  Future<void> _incrementAttempts() async {
    final userData = await _secureStorage.getUserData() ?? {};
    final attemptsStr = userData['pinCodeAttempts'] as String? ?? '0';
    final attempts = int.tryParse(attemptsStr) ?? 0;
    final newAttempts = attempts + 1;

    userData['pinCodeAttempts'] = newAttempts.toString();
    await _secureStorage.setUserData(userData);

    // Lock PIN code if max attempts reached
    if (newAttempts >= maxAttempts) {
      await _lockPinCode();
    }
  }

  /// Locks the PIN code.
  Future<void> _lockPinCode() async {
    final now = DateTime.now();
    final userData = await _secureStorage.getUserData() ?? {};
    userData['pinCodeLockTime'] = now.toIso8601String();
    await _secureStorage.setUserData(userData);
  }

  /// Resets the PIN code lock.
  Future<void> resetPinCodeLock() async {
    final userData = await _secureStorage.getUserData() ?? {};
    userData.remove('pinCodeLockTime');
    userData['pinCodeAttempts'] = '0';
    await _secureStorage.setUserData(userData);
  }
}
