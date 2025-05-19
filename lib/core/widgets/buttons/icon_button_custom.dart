import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

/// A custom icon button that can be used throughout the application.
/// 
/// This button can have different styles (filled, outlined, or transparent)
/// and can include an optional label.
class IconButtonCustom extends StatelessWidget {
  /// The icon to display.
  final IconData icon;
  
  /// The callback to execute when the button is pressed.
  final VoidCallback? onPressed;
  
  /// The style of the button (filled, outlined, or transparent).
  final IconButtonStyle style;
  
  /// Whether the button is disabled.
  final bool isDisabled;
  
  /// The size of the button.
  final double size;
  
  /// The size of the icon.
  final double iconSize;
  
  /// The color of the icon. If null, the color will be determined by the style.
  final Color? iconColor;
  
  /// An optional label to display below the icon.
  final String? label;
  
  /// The text style of the label.
  final TextStyle? labelStyle;
  
  /// The border radius of the button.
  final double borderRadius;

  const IconButtonCustom({
    Key? key,
    required this.icon,
    this.onPressed,
    this.style = IconButtonStyle.filled,
    this.isDisabled = false,
    this.size = 48.0,
    this.iconSize = 24.0,
    this.iconColor,
    this.label,
    this.labelStyle,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasLabel = label != null && label!.isNotEmpty;
    
    // Determine colors based on style and disabled state
    final Color backgroundColor = _getBackgroundColor();
    final Color foregroundColor = _getForegroundColor();
    final Color borderColor = _getBorderColor();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size.w,
          height: size.h,
          child: Material(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius.r),
              side: style == IconButtonStyle.outlined
                  ? BorderSide(color: borderColor, width: 1.5)
                  : BorderSide.none,
            ),
            child: InkWell(
              onTap: isDisabled ? null : onPressed,
              borderRadius: BorderRadius.circular(borderRadius.r),
              child: Center(
                child: Icon(
                  icon,
                  size: iconSize.sp,
                  color: iconColor ?? foregroundColor,
                ),
              ),
            ),
          ),
        ),
        if (hasLabel) ...[
          SizedBox(height: 4.h),
          Text(
            label!,
            style: labelStyle ?? TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDisabled ? AppColors.textDisabled : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
  
  /// Returns the background color based on the style and disabled state.
  Color _getBackgroundColor() {
    if (isDisabled) {
      switch (style) {
        case IconButtonStyle.filled:
          return AppColors.primary.withOpacity(0.5);
        case IconButtonStyle.outlined:
        case IconButtonStyle.transparent:
          return Colors.transparent;
      }
    }
    
    switch (style) {
      case IconButtonStyle.filled:
        return AppColors.primary;
      case IconButtonStyle.outlined:
      case IconButtonStyle.transparent:
        return Colors.transparent;
    }
  }
  
  /// Returns the foreground color based on the style and disabled state.
  Color _getForegroundColor() {
    if (isDisabled) {
      switch (style) {
        case IconButtonStyle.filled:
          return Colors.white.withOpacity(0.7);
        case IconButtonStyle.outlined:
        case IconButtonStyle.transparent:
          return AppColors.primary.withOpacity(0.5);
      }
    }
    
    switch (style) {
      case IconButtonStyle.filled:
        return Colors.white;
      case IconButtonStyle.outlined:
      case IconButtonStyle.transparent:
        return AppColors.primary;
    }
  }
  
  /// Returns the border color based on the style and disabled state.
  Color _getBorderColor() {
    if (isDisabled) {
      return AppColors.primary.withOpacity(0.5);
    }
    return AppColors.primary;
  }
  
  /// Creates a circular icon button.
  factory IconButtonCustom.circular({
    required IconData icon,
    required VoidCallback? onPressed,
    IconButtonStyle style = IconButtonStyle.filled,
    bool isDisabled = false,
    double size = 48.0,
    double iconSize = 24.0,
    Color? iconColor,
    String? label,
    TextStyle? labelStyle,
  }) {
    return IconButtonCustom(
      icon: icon,
      onPressed: onPressed,
      style: style,
      isDisabled: isDisabled,
      size: size,
      iconSize: iconSize,
      iconColor: iconColor,
      label: label,
      labelStyle: labelStyle,
      borderRadius: size / 2,
    );
  }
  
  /// Creates a small icon button.
  factory IconButtonCustom.small({
    required IconData icon,
    required VoidCallback? onPressed,
    IconButtonStyle style = IconButtonStyle.filled,
    bool isDisabled = false,
    double iconSize = 18.0,
    Color? iconColor,
    String? label,
    TextStyle? labelStyle,
    double borderRadius = 4.0,
  }) {
    return IconButtonCustom(
      icon: icon,
      onPressed: onPressed,
      style: style,
      isDisabled: isDisabled,
      size: 36.0,
      iconSize: iconSize,
      iconColor: iconColor,
      label: label,
      labelStyle: labelStyle,
      borderRadius: borderRadius,
    );
  }
}

/// The style of the icon button.
enum IconButtonStyle {
  /// A filled button with a background color.
  filled,
  
  /// An outlined button with a border.
  outlined,
  
  /// A transparent button with no background or border.
  transparent,
}
