import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import '../../theme/app_colors.dart';
import '../buttons/app_button.dart';
import '../buttons/button_type.dart';

enum BiometricResult {
  success,
  failed,
  notAvailable,
  notEnrolled,
  deviceNotSecure,
  userCancelled,
  unknown,
}

class BiometricPrompt extends StatefulWidget {
  final String title;
  final String subtitle;
  final String promptMessage;
  final String successMessage;
  final String errorMessage;
  final String notAvailableMessage;
  final String notEnrolledMessage;
  final String deviceNotSecureMessage;
  final String cancelButtonText;
  final String retryButtonText;
  final String usePasswordButtonText;
  final VoidCallback? onAuthenticated;
  final VoidCallback? onError;
  final VoidCallback? onCancel;
  final VoidCallback? onUsePassword;
  final bool showCancelButton;
  final bool showUsePasswordButton;
  final bool showRetryButton;
  final bool biometricOnly;
  final bool stickyAuth;
  final bool showLogo;
  final Widget? logo;
  final bool autoPrompt;
  final Duration autoPromptDelay;

  const BiometricPrompt({
    Key? key,
    this.title = 'Xác thực sinh trắc học',
    this.subtitle = 'Sử dụng vân tay hoặc khuôn mặt để xác thực',
    this.promptMessage = 'Xác thực để tiếp tục',
    this.successMessage = 'Xác thực thành công',
    this.errorMessage = 'Xác thực thất bại',
    this.notAvailableMessage = 'Thiết bị không hỗ trợ xác thực sinh trắc học',
    this.notEnrolledMessage = 'Vui lòng thiết lập xác thực sinh trắc học trong cài đặt thiết bị',
    this.deviceNotSecureMessage = 'Thiết bị không an toàn',
    this.cancelButtonText = 'Hủy',
    this.retryButtonText = 'Thử lại',
    this.usePasswordButtonText = 'Sử dụng mật khẩu',
    this.onAuthenticated,
    this.onError,
    this.onCancel,
    this.onUsePassword,
    this.showCancelButton = true,
    this.showUsePasswordButton = true,
    this.showRetryButton = true,
    this.biometricOnly = false,
    this.stickyAuth = true,
    this.showLogo = true,
    this.logo,
    this.autoPrompt = true,
    this.autoPromptDelay = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<BiometricPrompt> createState() => _BiometricPromptState();

  static Future<BiometricResult> authenticate({
    required BuildContext context,
    String promptMessage = 'Xác thực để tiếp tục',
    bool biometricOnly = false,
    bool stickyAuth = true,
  }) async {
    final localAuth = LocalAuthentication();
    
    try {
      // Check if biometrics is available
      final canCheckBiometrics = await localAuth.canCheckBiometrics;
      final isDeviceSupported = await localAuth.isDeviceSupported();
      
      if (!canCheckBiometrics || !isDeviceSupported) {
        return BiometricResult.notAvailable;
      }
      
      // Get available biometrics
      final availableBiometrics = await localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        return BiometricResult.notEnrolled;
      }
      
      // Authenticate
      final authenticated = await localAuth.authenticate(
        localizedReason: promptMessage,
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: stickyAuth,
        ),
      );
      
      return authenticated ? BiometricResult.success : BiometricResult.failed;
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
      // else if (e.code == auth_error.userCanceled) {
      //   return BiometricResult.userCancelled;
      // }
      return BiometricResult.unknown;
    } catch (e) {
      return BiometricResult.unknown;
    }
  }

  static Future<BiometricResult> showBiometricPrompt({
    required BuildContext context,
    String title = 'Xác thực sinh trắc học',
    String subtitle = 'Sử dụng vân tay hoặc khuôn mặt để xác thực',
    String promptMessage = 'Xác thực để tiếp tục',
    VoidCallback? onAuthenticated,
    VoidCallback? onError,
    VoidCallback? onCancel,
    VoidCallback? onUsePassword,
    bool biometricOnly = false,
    bool stickyAuth = true,
  }) async {
    final result = await showDialog<BiometricResult>(
      context: context,
      barrierDismissible: false,
      builder: (context) => BiometricPrompt(
        title: title,
        subtitle: subtitle,
        promptMessage: promptMessage,
        onAuthenticated: onAuthenticated,
        onError: onError,
        onCancel: onCancel,
        onUsePassword: onUsePassword,
        biometricOnly: biometricOnly,
        stickyAuth: stickyAuth,
      ),
    );
    
    return result ?? BiometricResult.userCancelled;
  }
}

class _BiometricPromptState extends State<BiometricPrompt> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  BiometricResult _authStatus = BiometricResult.unknown;
  bool _isAuthenticating = false;
  List<BiometricType> _availableBiometrics = [];
  bool _canCheckBiometrics = false;
  bool _isDeviceSupported = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      _canCheckBiometrics = await _localAuth.canCheckBiometrics;
      _isDeviceSupported = await _localAuth.isDeviceSupported();
      
      if (_canCheckBiometrics && _isDeviceSupported) {
        _availableBiometrics = await _localAuth.getAvailableBiometrics();
        
        if (_availableBiometrics.isEmpty) {
          setState(() {
            _authStatus = BiometricResult.notEnrolled;
          });
        } else if (widget.autoPrompt) {
          // Delay to allow dialog to show first
          Future.delayed(widget.autoPromptDelay, () {
            if (mounted) {
              _authenticate();
            }
          });
        }
      } else {
        setState(() {
          _authStatus = BiometricResult.notAvailable;
        });
      }
    } on PlatformException {
      setState(() {
        _authStatus = BiometricResult.unknown;
      });
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;
    
    setState(() {
      _isAuthenticating = true;
      _authStatus = BiometricResult.unknown;
    });
    
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: widget.promptMessage,
        options: AuthenticationOptions(
          biometricOnly: widget.biometricOnly,
          stickyAuth: widget.stickyAuth,
        ),
      );
      
      setState(() {
        _authStatus = authenticated ? BiometricResult.success : BiometricResult.failed;
        _isAuthenticating = false;
      });
      
      if (authenticated) {
        if (widget.onAuthenticated != null) {
          widget.onAuthenticated!();
        }

          Navigator.of(context).pop(BiometricResult.success);

      } else if (widget.onError != null) {
        widget.onError!();
      }
    } on PlatformException catch (e) {
      BiometricResult result;
      
      if (e.code == auth_error.notEnrolled) {
        result = BiometricResult.notEnrolled;
      } else if (e.code == auth_error.notAvailable) {
        result = BiometricResult.notAvailable;
      } else if (e.code == auth_error.lockedOut ||
                e.code == auth_error.permanentlyLockedOut) {
        result = BiometricResult.failed;
      } else if (e.code == auth_error.passcodeNotSet) {
        result = BiometricResult.deviceNotSecure;
      }
      // else if (e.code == auth_error.userCanceled) {
      //   result = BiometricResult.userCancelled;
      // }
      else {
        result = BiometricResult.unknown;
      }
      
      setState(() {
        _authStatus = result;
        _isAuthenticating = false;
      });
      
      if (widget.onError != null) {
        widget.onError!();
      }
    }
  }

  void _cancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    Navigator.of(context).pop(BiometricResult.userCancelled);
  }

  void _usePassword() {
    if (widget.onUsePassword != null) {
      widget.onUsePassword!();
    }
    Navigator.of(context).pop(BiometricResult.userCancelled);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showLogo) ...[
              widget.logo ??
                  Icon(
                    _getBiometricIcon(),
                    size: 64.sp,
                    color: AppColors.primary,
                  ),
              SizedBox(height: 16.h),
            ],
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              widget.subtitle,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            _buildStatusMessage(),
            SizedBox(height: 24.h),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusMessage() {
    String message;
    Color color;
    IconData icon;
    
    switch (_authStatus) {
      case BiometricResult.success:
        message = widget.successMessage;
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case BiometricResult.failed:
        message = widget.errorMessage;
        color = AppColors.error;
        icon = Icons.error;
        break;
      case BiometricResult.notAvailable:
        message = widget.notAvailableMessage;
        color = AppColors.warning;
        icon = Icons.warning;
        break;
      case BiometricResult.notEnrolled:
        message = widget.notEnrolledMessage;
        color = AppColors.warning;
        icon = Icons.fingerprint;
        break;
      case BiometricResult.deviceNotSecure:
        message = widget.deviceNotSecureMessage;
        color = AppColors.error;
        icon = Icons.security;
        break;
      case BiometricResult.userCancelled:
        message = 'Xác thực đã bị hủy';
        color = AppColors.warning;
        icon = Icons.cancel;
        break;
      case BiometricResult.unknown:
      if (_isAuthenticating) {
          message = widget.promptMessage;
          color = AppColors.primary;
          icon = _getBiometricIcon();
        } else {
          message = 'Nhấn "Thử lại" để bắt đầu xác thực';
          color = AppColors.info;
          icon = Icons.info;
        }
        break;
    }
    
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 24.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    final List<Widget> buttons = [];
    
    if (_authStatus == BiometricResult.success) {
      // No buttons needed on success
      return const SizedBox.shrink();
    }
    
    if (widget.showRetryButton &&
        (_authStatus == BiometricResult.failed ||
         _authStatus == BiometricResult.unknown ||
         _authStatus == BiometricResult.userCancelled)) {
      buttons.add(
        AppButton(
          text: widget.retryButtonText,
          onPressed: _authenticate,
          buttonType: ButtonType.primary,
        ),
      );
    }
    
    if (widget.showUsePasswordButton) {
      buttons.add(
        AppButton(
          text: widget.usePasswordButtonText,
          onPressed: _usePassword,
          buttonType: ButtonType.outline,
        ),
      );
    }
    
    if (widget.showCancelButton) {
      buttons.add(
        AppButton(
          text: widget.cancelButtonText,
          onPressed: _cancel,
          buttonType: ButtonType.text,
        ),
      );
    }
    
    return Column(
      children: buttons.map((button) {
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: SizedBox(
            width: double.infinity,
            child: button,
          ),
        );
      }).toList(),
    );
  }

  IconData _getBiometricIcon() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return Icons.face;
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    } else if (_availableBiometrics.contains(BiometricType.iris)) {
      return Icons.remove_red_eye;
    } else {
      return Icons.security;
    }
  }
}
