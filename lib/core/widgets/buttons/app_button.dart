import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'button_type.dart';
import '../../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonType buttonType;
  final bool isDisabled;
  final IconData? icon;
  final IconPosition iconPosition;
  final double? width;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.buttonType = ButtonType.primary,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.width,
    this.height = 48.0,
    this.borderRadius = 8.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine button style based on type
    final ButtonStyle buttonStyle = _getButtonStyle(theme);

    // Determine text style based on type
    final TextStyle defaultTextStyle = _getTextStyle(theme);

    // Determine if button should be disabled
    final bool isButtonDisabled = isDisabled || isLoading;

    return SizedBox(
      width: width,
      height: height.h,
      child: ElevatedButton(
        onPressed: isButtonDisabled ? null : onPressed,
        style: buttonStyle,
        child: _buildButtonContent(defaultTextStyle),
      ),
    );
  }

  Widget _buildButtonContent(TextStyle defaultTextStyle) {
    if (isLoading) {
      return SizedBox(
        height: 20.h,
        width: 20.h,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            buttonType == ButtonType.primary ? Colors.white : AppColors.primary,
          ),
        ),
      );
    }

    if (icon == null) {
      return Text(
        text,
        style: textStyle ?? defaultTextStyle,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconPosition == IconPosition.left) ...[
          Icon(icon, size: 18.sp),
          SizedBox(width: 8.w),
        ],
        Text(
          text,
          style: textStyle ?? defaultTextStyle,
        ),
        if (iconPosition == IconPosition.right) ...[
          SizedBox(width: 8.w),
          Icon(icon, size: 18.sp),
        ],
      ],
    );
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    switch (buttonType) {
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        );
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.secondary.withValues(alpha: 0.5),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        );
      case ButtonType.outline:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: AppColors.primary.withValues(alpha: 0.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            side: BorderSide(
              color: isDisabled
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.primary,
              width: 1.5,
            ),
          ),
        );
      case ButtonType.text:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: AppColors.primary.withValues(alpha: 0.5),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        );
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    final baseStyle = TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
    );

    switch (buttonType) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return baseStyle.copyWith(color: Colors.white);
      case ButtonType.outline:
      case ButtonType.text:
        return baseStyle.copyWith(color: AppColors.primary);
    }
  }
}

// Biến thể của AppButton
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final ButtonType buttonType;
  final bool isDisabled;
  final double size;
  final double iconSize;
  final Color? iconColor;

  const AppIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.buttonType = ButtonType.primary,
    this.isDisabled = false,
    this.size = 48.0,
    this.iconSize = 24.0,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: '',
      onPressed: onPressed,
      buttonType: buttonType,
      isDisabled: isDisabled,
      icon: icon,
      width: size.w,
      height: size.h,
      textStyle: const TextStyle(fontSize: 0), // Hide text
    );
  }
}

class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final IconData? icon;
  final IconPosition iconPosition;

  const AppTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = IconPosition.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      buttonType: ButtonType.text,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final IconPosition iconPosition;
  final double? width;
  final double height;

  const AppOutlineButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.width,
    this.height = 48.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      buttonType: ButtonType.outline,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
      height: height,
    );
  }
}
