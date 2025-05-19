import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../buttons/app_button.dart';
import '../buttons/button_type.dart';

enum PermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
  unknown,
}

class AppPermissionHandler extends StatelessWidget {
  final String permission;
  final String title;
  final String description;
  final String rationaleMessage;
  final String grantButtonText;
  final String settingsButtonText;
  final String cancelButtonText;
  final VoidCallback? onGranted;
  final VoidCallback? onDenied;
  final VoidCallback? onOpenSettings;
  final VoidCallback? onCancel;
  final Widget? icon;
  final bool showIcon;
  final bool showCancelButton;
  final EdgeInsetsGeometry padding;
  final PermissionStatus status;

  const AppPermissionHandler({
    Key? key,
    required this.permission,
    required this.title,
    required this.description,
    this.rationaleMessage = 'Ứng dụng cần quyền này để hoạt động đúng.',
    this.grantButtonText = 'Cấp quyền',
    this.settingsButtonText = 'Mở cài đặt',
    this.cancelButtonText = 'Hủy',
    this.onGranted,
    this.onDenied,
    this.onOpenSettings,
    this.onCancel,
    this.icon,
    this.showIcon = true,
    this.showCancelButton = true,
    this.padding = const EdgeInsets.all(24),
    this.status = PermissionStatus.unknown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon) ...[
              icon ??
                  Icon(
                    _getPermissionIcon(),
                    size: 64.sp,
                    color: AppColors.primary,
                  ),
              SizedBox(height: 16.h),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              rationaleMessage,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    final List<Widget> buttons = [];
    
    if (status == PermissionStatus.permanentlyDenied || 
        status == PermissionStatus.restricted) {
      buttons.add(
        AppButton(
          text: settingsButtonText,
          onPressed: onOpenSettings,
          buttonType: ButtonType.primary,
        ),
      );
    } else {
      buttons.add(
        AppButton(
          text: grantButtonText,
          onPressed: onGranted,
          buttonType: ButtonType.primary,
        ),
      );
    }
    
    if (showCancelButton) {
      buttons.add(
        AppButton(
          text: cancelButtonText,
          onPressed: onCancel,
          buttonType: ButtonType.outline,
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

  IconData _getPermissionIcon() {
    switch (permission.toLowerCase()) {
      case 'camera':
        return Icons.camera_alt;
      case 'photos':
      case 'gallery':
      case 'storage':
        return Icons.photo_library;
      case 'location':
        return Icons.location_on;
      case 'microphone':
        return Icons.mic;
      case 'contacts':
        return Icons.contacts;
      case 'calendar':
        return Icons.calendar_today;
      case 'notifications':
        return Icons.notifications;
      case 'phone':
        return Icons.phone;
      case 'sms':
        return Icons.sms;
      case 'biometrics':
        return Icons.fingerprint;
      default:
        return Icons.security;
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required String permission,
    required String title,
    required String description,
    String rationaleMessage = 'Ứng dụng cần quyền này để hoạt động đúng.',
    String grantButtonText = 'Cấp quyền',
    String settingsButtonText = 'Mở cài đặt',
    String cancelButtonText = 'Hủy',
    VoidCallback? onGranted,
    VoidCallback? onDenied,
    VoidCallback? onOpenSettings,
    VoidCallback? onCancel,
    Widget? icon,
    bool showIcon = true,
    bool showCancelButton = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    PermissionStatus status = PermissionStatus.unknown,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AppPermissionHandler(
        permission: permission,
        title: title,
        description: description,
        rationaleMessage: rationaleMessage,
        grantButtonText: grantButtonText,
        settingsButtonText: settingsButtonText,
        cancelButtonText: cancelButtonText,
        onGranted: onGranted ?? () => Navigator.of(context).pop(true),
        onDenied: onDenied,
        onOpenSettings: onOpenSettings ?? () => Navigator.of(context).pop(false),
        onCancel: onCancel ?? () => Navigator.of(context).pop(false),
        icon: icon,
        showIcon: showIcon,
        showCancelButton: showCancelButton,
        padding: padding,
        status: status,
      ),
    );
  }
}

class PermissionDeniedWidget extends StatelessWidget {
  final String permission;
  final String title;
  final String description;
  final String settingsButtonText;
  final VoidCallback? onOpenSettings;
  final Widget? icon;
  final bool showIcon;
  final EdgeInsetsGeometry padding;
  final bool isCompact;

  const PermissionDeniedWidget({
    Key? key,
    required this.permission,
    required this.title,
    required this.description,
    this.settingsButtonText = 'Mở cài đặt',
    this.onOpenSettings,
    this.icon,
    this.showIcon = true,
    this.padding = const EdgeInsets.all(16),
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isCompact) {
      return Padding(
        padding: padding,
        child: Row(
          children: [
            if (showIcon) ...[
              icon ??
                  Icon(
                    _getPermissionIcon(),
                    color: AppColors.warning,
                    size: 24.sp,
                  ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onOpenSettings,
              child: Text(settingsButtonText),
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon) ...[
            icon ??
                Icon(
                  _getPermissionIcon(),
                  color: AppColors.warning,
                  size: 64.sp,
                ),
            SizedBox(height: 16.h),
          ],
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          AppButton(
            text: settingsButtonText,
            onPressed: onOpenSettings,
            buttonType: ButtonType.primary,
          ),
        ],
      ),
    );
  }

  IconData _getPermissionIcon() {
    switch (permission.toLowerCase()) {
      case 'camera':
        return Icons.camera_alt;
      case 'photos':
      case 'gallery':
      case 'storage':
        return Icons.photo_library;
      case 'location':
        return Icons.location_on;
      case 'microphone':
        return Icons.mic;
      case 'contacts':
        return Icons.contacts;
      case 'calendar':
        return Icons.calendar_today;
      case 'notifications':
        return Icons.notifications;
      case 'phone':
        return Icons.phone;
      case 'sms':
        return Icons.sms;
      case 'biometrics':
        return Icons.fingerprint;
      default:
        return Icons.security;
    }
  }
}
