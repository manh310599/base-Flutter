import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  final int? count;
  final Color color;
  final Color textColor;
  final double size;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final bool showZero;
  final int maxCount;
  final VoidCallback? onTap;
  final String? text;
  final TextStyle? textStyle;
  final double? minWidth;
  final double? minHeight;

  const AppBadge({
    Key? key,
    this.count,
    this.color = AppColors.error,
    this.textColor = Colors.white,
    this.size = 20.0,
    this.child,
    this.padding = const EdgeInsets.all(0),
    this.showZero = false,
    this.maxCount = 99,
    this.onTap,
    this.text,
    this.textStyle,
    this.minWidth,
    this.minHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if badge should be shown
    final shouldShowBadge = text != null ||
        (count != null && (count! > 0 || showZero));
    
    // If no badge and no child, return empty container
    if (!shouldShowBadge && child == null) {
      return const SizedBox.shrink();
    }
    
    // If no badge but has child, return just the child
    if (!shouldShowBadge && child != null) {
      return child!;
    }
    
    // Determine badge content
    final String badgeText = text ?? 
        (count! > maxCount ? '$maxCount+' : count.toString());
    
    // Build badge
    final badge = Container(
      constraints: BoxConstraints(
        minWidth: minWidth ?? size.w,
        minHeight: minHeight ?? size.h,
      ),
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        shape: text != null || badgeText.length > 1 
            ? BoxShape.rectangle 
            : BoxShape.circle,
        borderRadius: text != null || badgeText.length > 1 
            ? BorderRadius.circular(size.r / 2) 
            : null,
      ),
      child: Center(
        child: Padding(
          padding: text != null || badgeText.length > 1 
              ? EdgeInsets.symmetric(horizontal: 6.w) 
              : EdgeInsets.zero,
          child: Text(
            badgeText,
            style: textStyle ?? 
                TextStyle(
                  color: textColor,
                  fontSize: size.sp / 1.8,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    
    // If no child, return just the badge
    if (child == null) {
      return GestureDetector(
        onTap: onTap,
        child: badge,
      );
    }
    
    // Return child with badge positioned on top-right
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: child!,
        ),
        Positioned(
          top: -5.h,
          right: -5.w,
          child: badge,
        ),
      ],
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final double height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final Widget? icon;
  final double iconSpacing;

  const StatusBadge({
    Key? key,
    required this.text,
    required this.color,
    this.textColor = Colors.white,
    this.height = 24.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.borderRadius = 12.0,
    this.onTap,
    this.textStyle,
    this.icon,
    this.iconSpacing = 4.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      height: height.h,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: iconSpacing.w),
            ],
            Text(
              text,
              style: textStyle ?? 
                  TextStyle(
                    color: textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: badge,
      );
    }
    
    return badge;
  }

  // Factory constructors for common status types
  factory StatusBadge.pending({
    required String text,
    VoidCallback? onTap,
    TextStyle? textStyle,
    Widget? icon,
    double iconSpacing = 4.0,
  }) {
    return StatusBadge(
      text: text,
      color: AppColors.pending,
      onTap: onTap,
      textStyle: textStyle,
      icon: icon,
      iconSpacing: iconSpacing,
    );
  }

  factory StatusBadge.completed({
    required String text,
    VoidCallback? onTap,
    TextStyle? textStyle,
    Widget? icon,
    double iconSpacing = 4.0,
  }) {
    return StatusBadge(
      text: text,
      color: AppColors.completed,
      onTap: onTap,
      textStyle: textStyle,
      icon: icon,
      iconSpacing: iconSpacing,
    );
  }

  factory StatusBadge.failed({
    required String text,
    VoidCallback? onTap,
    TextStyle? textStyle,
    Widget? icon,
    double iconSpacing = 4.0,
  }) {
    return StatusBadge(
      text: text,
      color: AppColors.failed,
      onTap: onTap,
      textStyle: textStyle,
      icon: icon,
      iconSpacing: iconSpacing,
    );
  }

  factory StatusBadge.draft({
    required String text,
    VoidCallback? onTap,
    TextStyle? textStyle,
    Widget? icon,
    double iconSpacing = 4.0,
  }) {
    return StatusBadge(
      text: text,
      color: AppColors.draft,
      onTap: onTap,
      textStyle: textStyle,
      icon: icon,
      iconSpacing: iconSpacing,
    );
  }
}
