import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../buttons/app_button.dart';
import '../buttons/button_type.dart';

class AppDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool barrierDismissible;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double borderRadius;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final double? width;
  final double? maxWidth;
  final double? maxHeight;
  final MainAxisAlignment actionsAlignment;
  final CrossAxisAlignment titleAlignment;
  final TextStyle? titleStyle;

  const AppDialog({
    Key? key,
    this.title,
    required this.content,
    this.actions,
    this.barrierDismissible = true,
    this.padding = const EdgeInsets.all(24),
    this.backgroundColor = Colors.white,
    this.borderRadius = 16.0,
    this.showCloseButton = false,
    this.onClose,
    this.width,
    this.maxWidth = 400,
    this.maxHeight,
    this.actionsAlignment = MainAxisAlignment.end,
    this.titleAlignment = CrossAxisAlignment.center,
    this.titleStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: Container(
        width: width,
        constraints: BoxConstraints(
          maxWidth: maxWidth?.w ?? double.infinity,
          maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || showCloseButton) ...[
              Padding(
                padding: EdgeInsets.only(
                  left: padding.horizontal / 2,
                  right: padding.horizontal / 2,
                  top: padding.vertical / 2,
                  bottom: title != null ? padding.vertical / 4 : padding.vertical / 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (title != null)
                      Expanded(
                        child: Align(
                          alignment: _getAlignmentFromCrossAxisAlignment(titleAlignment),
                          child: Text(
                            title!,
                            style: titleStyle ??
                                TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                            textAlign: _getTextAlignFromCrossAxisAlignment(titleAlignment),
                          ),
                        ),
                      )
                    else
                      const Spacer(),
                    if (showCloseButton)
                      IconButton(
                        icon: Icon(Icons.close, size: 24.sp),
                        onPressed: () {
                          if (onClose != null) {
                            onClose!();
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ),
              if (title != null)
                Divider(height: 1.h, thickness: 1.h, color: AppColors.divider),
            ],
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: padding.horizontal / 2,
                  right: padding.horizontal / 2,
                  top: (title != null || showCloseButton) ? padding.vertical / 2 : padding.vertical,
                  bottom: actions != null && actions!.isNotEmpty ? 0 : padding.vertical,
                ),
                child: content,
              ),
            ),
            if (actions != null && actions!.isNotEmpty) ...[
              Divider(height: 1.h, thickness: 1.h, color: AppColors.divider),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  mainAxisAlignment: actionsAlignment,
                  children: actions!
                      .map((action) => Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: action,
                          ))
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Alignment _getAlignmentFromCrossAxisAlignment(CrossAxisAlignment alignment) {
    switch (alignment) {
      case CrossAxisAlignment.start:
        return Alignment.centerLeft;
      case CrossAxisAlignment.end:
        return Alignment.centerRight;
      case CrossAxisAlignment.center:
      default:
        return Alignment.center;
    }
  }

  TextAlign _getTextAlignFromCrossAxisAlignment(CrossAxisAlignment alignment) {
    switch (alignment) {
      case CrossAxisAlignment.start:
        return TextAlign.left;
      case CrossAxisAlignment.end:
        return TextAlign.right;
      case CrossAxisAlignment.center:
      default:
        return TextAlign.center;
    }
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool barrierDismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
    Color backgroundColor = Colors.white,
    double borderRadius = 16.0,
    bool showCloseButton = false,
    VoidCallback? onClose,
    double? width,
    double? maxWidth = 400,
    double? maxHeight,
    MainAxisAlignment actionsAlignment = MainAxisAlignment.end,
    CrossAxisAlignment titleAlignment = CrossAxisAlignment.center,
    TextStyle? titleStyle,
    bool useRootNavigator = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) => AppDialog(
        title: title,
        content: content,
        actions: actions,
        barrierDismissible: barrierDismissible,
        padding: padding,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        showCloseButton: showCloseButton,
        onClose: onClose,
        width: width,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        actionsAlignment: actionsAlignment,
        titleAlignment: titleAlignment,
        titleStyle: titleStyle,
      ),
    );
  }
}

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool barrierDismissible;
  final Widget? icon;

  const AppConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText = 'Đồng ý',
    this.cancelText = 'Hủy',
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.barrierDismissible = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      barrierDismissible: barrierDismissible,
      titleAlignment: CrossAxisAlignment.center,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            SizedBox(height: 16.h),
            icon!,
            SizedBox(height: 16.h),
          ],
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        AppButton(
          text: cancelText,
          buttonType: ButtonType.outline,
          onPressed: () {
            Navigator.of(context).pop(false);
            if (onCancel != null) {
              onCancel!();
            }
          },
        ),
        AppButton(
          text: confirmText,
          buttonType: isDestructive ? ButtonType.secondary : ButtonType.primary,
          onPressed: () {
            Navigator.of(context).pop(true);
            if (onConfirm != null) {
              onConfirm!();
            }
          },
        ),
      ],
    );
  }

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Đồng ý',
    String cancelText = 'Hủy',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
    bool barrierDismissible = true,
    Widget? icon,
    bool useRootNavigator = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) => AppConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        isDestructive: isDestructive,
        barrierDismissible: barrierDismissible,
        icon: icon,
      ),
    );
  }
}

class AppSuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool barrierDismissible;
  final Widget? icon;

  const AppSuccessDialog({
    Key? key,
    this.title = 'Thành công',
    required this.message,
    this.buttonText = 'Đóng',
    this.onPressed,
    this.barrierDismissible = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      barrierDismissible: barrierDismissible,
      titleAlignment: CrossAxisAlignment.center,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          icon ??
              Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64.sp,
              ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        AppButton(
          text: buttonText,
          onPressed: () {
            Navigator.of(context).pop();
            if (onPressed != null) {
              onPressed!();
            }
          },
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  static Future<void> show({
    required BuildContext context,
    String title = 'Thành công',
    required String message,
    String buttonText = 'Đóng',
    VoidCallback? onPressed,
    bool barrierDismissible = true,
    Widget? icon,
    bool useRootNavigator = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) => AppSuccessDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        barrierDismissible: barrierDismissible,
        icon: icon,
      ),
    );
  }
}

class AppErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool barrierDismissible;
  final Widget? icon;
  final String? retryText;
  final VoidCallback? onRetry;

  const AppErrorDialog({
    Key? key,
    this.title = 'Lỗi',
    required this.message,
    this.buttonText = 'Đóng',
    this.onPressed,
    this.barrierDismissible = true,
    this.icon,
    this.retryText,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      barrierDismissible: barrierDismissible,
      titleAlignment: CrossAxisAlignment.center,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          icon ??
              Icon(
                Icons.error,
                color: AppColors.error,
                size: 64.sp,
              ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        AppButton(
          text: buttonText,
          onPressed: () {
            Navigator.of(context).pop();
            if (onPressed != null) {
              onPressed!();
            }
          },
        ),
        if (retryText != null && onRetry != null)
          AppButton(
            text: retryText!,
            buttonType: ButtonType.primary,
            onPressed: () {
              Navigator.of(context).pop();
              onRetry!();
            },
          ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  static Future<void> show({
    required BuildContext context,
    String title = 'Lỗi',
    required String message,
    String buttonText = 'Đóng',
    VoidCallback? onPressed,
    bool barrierDismissible = true,
    Widget? icon,
    String? retryText,
    VoidCallback? onRetry,
    bool useRootNavigator = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) => AppErrorDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        barrierDismissible: barrierDismissible,
        icon: icon,
        retryText: retryText,
        onRetry: onRetry,
      ),
    );
  }
}

class AppInfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool barrierDismissible;
  final Widget? icon;

  const AppInfoDialog({
    Key? key,
    this.title = 'Thông tin',
    required this.message,
    this.buttonText = 'Đóng',
    this.onPressed,
    this.barrierDismissible = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      barrierDismissible: barrierDismissible,
      titleAlignment: CrossAxisAlignment.center,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16.h),
          icon ??
              Icon(
                Icons.info,
                color: AppColors.info,
                size: 64.sp,
              ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        AppButton(
          text: buttonText,
          onPressed: () {
            Navigator.of(context).pop();
            if (onPressed != null) {
              onPressed!();
            }
          },
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  static Future<void> show({
    required BuildContext context,
    String title = 'Thông tin',
    required String message,
    String buttonText = 'Đóng',
    VoidCallback? onPressed,
    bool barrierDismissible = true,
    Widget? icon,
    bool useRootNavigator = true,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (context) => AppInfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onPressed: onPressed,
        barrierDismissible: barrierDismissible,
        icon: icon,
      ),
    );
  }
}
