import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_button.dart';
import 'button_type.dart';

/// A secondary button with teal background and white text.
/// 
/// This button is used for secondary actions in the app.
/// It has a loading state and can be disabled.
class SecondaryButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;
  
  /// The callback to execute when the button is pressed.
  final VoidCallback? onPressed;
  
  /// Whether the button is in a loading state.
  final bool isLoading;
  
  /// Whether the button is disabled.
  final bool isDisabled;
  
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

  const SecondaryButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.width,
    this.height = 48.0,
    this.borderRadius = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      buttonType: ButtonType.secondary,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
  
  /// Creates a full-width secondary button.
  factory SecondaryButton.fullWidth({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    double height = 48.0,
    double borderRadius = 8.0,
  }) {
    return SecondaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
      width: double.infinity,
      height: height,
      borderRadius: borderRadius,
    );
  }
  
  /// Creates a small secondary button with reduced height.
  factory SecondaryButton.small({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    IconData? icon,
    IconPosition iconPosition = IconPosition.left,
    double? width,
    double borderRadius = 8.0,
  }) {
    return SecondaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      icon: icon,
      iconPosition: iconPosition,
      width: width,
      height: 36.0,
      borderRadius: borderRadius,
    );
  }
}
