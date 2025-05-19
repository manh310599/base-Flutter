import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

enum BiometricResult {
  success,
  failed,
  notAvailable,
  notEnrolled,
  deviceNotSecure,
  userCancelled,
}

@singleton
class BiometricsService {
  final LocalAuthentication _localAuth;
  
  BiometricsService(this._localAuth);

  /// Check if device is rooted/jailbroken
  Future<bool> isDeviceSecure() async {
    try {
      final isRooted = await FlutterJailbreakDetection.jailbroken;
      return !isRooted;
    } catch (e) {
      // If detection fails, assume device is secure but log the error
      return true;
    }
  }

  /// Check if biometrics is available on the device
  Future<bool> isBiometricsAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics && 
             await _localAuth.isDeviceSupported();
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return [];
    }
  }

  /// Authenticate with biometrics
  Future<BiometricResult> authenticate({
    required String reason,
    bool biometricOnly = false,
  }) async {
    // First check if device is secure
    final isSecure = await isDeviceSecure();
    if (!isSecure) {
      return BiometricResult.deviceNotSecure;
    }

    // Check if biometrics is available
    final canUseBiometrics = await isBiometricsAvailable();
    if (!canUseBiometrics) {
      return BiometricResult.notAvailable;
    }

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
        ),
      );

      return authenticated 
          ? BiometricResult.success 
          : BiometricResult.failed;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        return BiometricResult.notEnrolled;
      } else if (e.code == auth_error.notAvailable) {
        return BiometricResult.notAvailable;
      } else if (e.code == auth_error.lockedOut ||
                e.code == auth_error.permanentlyLockedOut) {
        return BiometricResult.failed;
      } else if (e.code == auth_error.passcodeNotSet) {
        return BiometricResult.deviceNotSecure;
      }
      // else if (e.code == auth_error.) {
      //   return BiometricResult.userCancelled;
      // }
      return BiometricResult.failed;
    }
  }
}
