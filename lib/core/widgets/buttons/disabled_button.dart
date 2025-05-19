import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

/// A disabled button that cannot be pressed.
/// 
/// This button is used to show that an action is not available.
/// It can be conditionally disabled based on a condition.
class DisabledButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;
  
  /// Whether the button should be disabled.
  /// If false, the onPressed callback will be executed when the button is pressed.
  final bool isDisabled;
  
  /// The callback to execute when the button is pressed (if not disabled).
  final VoidCallback? onPressed;
  
  /// An optional icon to display on the button.
  final IconData? icon;
  
  /// The position of the icon (left or right).
  final IconPosition iconPosition;
  
  /// The width of the button. If null, the button will take the width of its parent.
  final double? width;
  
  /// The height of the button.
  final double height;
  
  /// The border radius of the button.
  final double borderRadius;
  
  /// The background color of the button when disabled.
  final Color disabledBackgroundColor;
  
  /// The text color of the button when disabled.
  final Color disabledTextColor;

  const DisabledButton({
    Key? key,
    required this.text,
    this.isDisabled = true,
    this.onPressed,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.width,
    this.height = 48.0,
    this.borderRadius = 8.0,
    this.disabledBackgroundColor = const Color(0xFFE0E0E0),
    this.disabledTextColor = const Color(0xFF9E9E9E),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height.h,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? disabledBackgroundColor : AppColors.primary,
          foregroundColor: isDisabled ? disabledTextColor : Colors.white,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledTextColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
          ),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (icon == null) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
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
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (iconPosition == IconPosition.right) ...[
          SizedBox(width: 8.w),
          Icon(icon, size: 18.sp),
        ],
      ],
    );
  }
  
  /// Creates a full-width disabled button.
  factory DisabledButton.fullWidth({
    required String text,
    bool isDisabled = true,
    VoidCallback? onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    double height = 48.0,
    double borderRadius = 8.0,
    Color disabledBackgroundColor = const Color(0xFFE0E0E0),
    Color disabledTextColor = const Color(0xFF9E9E9E),
  }) {
    return DisabledButton(
      text: text,
      isDisabled: isDisabled,
      onPressed: onPressed,
      icon: icon,
      iconPosition: iconPosition,
      width: double.infinity,
      height: height,
      borderRadius: borderRadius,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledTextColor: disabledTextColor,
    );
  }
  
  /// Creates a conditionally disabled button.
  /// 
  /// If [condition] is true, the button will be disabled.
  /// Otherwise, the button will be enabled and [onPressed] will be called when pressed.
  factory DisabledButton.conditional({
    required String text,
    required bool condition,
    required VoidCallback onPressed,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    double? width,
    double height = 48.0,
    double borderRadius = 8.0,
    Color disabledBackgroundColor = const Color(0xFFE0E0E0),
    Color disabledTextColor = const Color(0xFF9E9E9E),
  }) {
    return DisabledButton(
      text: text,
      isDisabled: condition,
      onPressed: onPressed,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
      height: height,
      borderRadius: borderRadius,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledTextColor: disabledTextColor,
    );
  }
}

/// The position of the icon.
enum IconPosition {
  left,
  right,
}
