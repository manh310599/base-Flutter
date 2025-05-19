import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Dimensions used throughout the app.
/// 
/// This class contains all the dimension values used in the app.
/// Using this class ensures consistency across the app.
class AppDimens {
  // Base dimensions
  static const double baseSpacing = 8.0;
  static const double baseRadius = 8.0;
  static const double baseBorderWidth = 1.0;
  static const double baseElevation = 2.0;
  
  // Spacing
  static double get spacing2 => baseSpacing * 0.25;  // 2dp
  static double get spacing4 => baseSpacing * 0.5;   // 4dp
  static double get spacing8 => baseSpacing;         // 8dp
  static double get spacing12 => baseSpacing * 1.5;  // 12dp
  static double get spacing16 => baseSpacing * 2;    // 16dp
  static double get spacing20 => baseSpacing * 2.5;  // 20dp
  static double get spacing24 => baseSpacing * 3;    // 24dp
  static double get spacing32 => baseSpacing * 4;    // 32dp
  static double get spacing40 => baseSpacing * 5;    // 40dp
  static double get spacing48 => baseSpacing * 6;    // 48dp
  static double get spacing56 => baseSpacing * 7;    // 56dp
  static double get spacing64 => baseSpacing * 8;    // 64dp
  
  // Responsive spacing (using ScreenUtil)
  static double get spacingXs => 4.w;
  static double get spacingSm => 8.w;
  static double get spacingMd => 16.w;
  static double get spacingLg => 24.w;
  static double get spacingXl => 32.w;
  static double get spacing2xl => 48.w;
  static double get spacing3xl => 64.w;
  
  // Border radius
  static double get radiusXs => 4.r;
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;
  static double get radiusXl => 24.r;
  static double get radiusCircular => 100.r;
  
  // Border width
  static double get borderWidthThin => 0.5;
  static double get borderWidthRegular => 1.0;
  static double get borderWidthThick => 2.0;
  
  // Elevation
  static double get elevationNone => 0.0;
  static double get elevationXs => 1.0;
  static double get elevationSm => 2.0;
  static double get elevationMd => 4.0;
  static double get elevationLg => 8.0;
  static double get elevationXl => 16.0;
  
  // Icon sizes
  static double get iconSizeXs => 16.sp;
  static double get iconSizeSm => 20.sp;
  static double get iconSizeMd => 24.sp;
  static double get iconSizeLg => 32.sp;
  static double get iconSizeXl => 48.sp;
  
  // Button sizes
  static double get buttonHeightSm => 32.h;
  static double get buttonHeightMd => 40.h;
  static double get buttonHeightLg => 48.h;
  static double get buttonHeightXl => 56.h;
  
  // Input field sizes
  static double get inputHeightSm => 40.h;
  static double get inputHeightMd => 48.h;
  static double get inputHeightLg => 56.h;
  
  // Text field padding
  static EdgeInsets get inputPaddingHorizontal => EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get inputPaddingVertical => EdgeInsets.symmetric(vertical: 12.h);
  static EdgeInsets get inputPadding => EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);
  
  // Card padding
  static EdgeInsets get cardPaddingSm => EdgeInsets.all(8.w);
  static EdgeInsets get cardPaddingMd => EdgeInsets.all(16.w);
  static EdgeInsets get cardPaddingLg => EdgeInsets.all(24.w);
  
  // Screen padding
  static EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
  static EdgeInsets get screenPaddingHorizontal => EdgeInsets.symmetric(horizontal: 16.w);
  static EdgeInsets get screenPaddingVertical => EdgeInsets.symmetric(vertical: 16.h);
  
  // List item sizes
  static double get listItemHeightSm => 48.h;
  static double get listItemHeightMd => 64.h;
  static double get listItemHeightLg => 80.h;
  
  // Avatar sizes
  static double get avatarSizeXs => 24.w;
  static double get avatarSizeSm => 32.w;
  static double get avatarSizeMd => 40.w;
  static double get avatarSizeLg => 56.w;
  static double get avatarSizeXl => 80.w;
  
  // Badge sizes
  static double get badgeSizeSm => 16.w;
  static double get badgeSizeMd => 20.w;
  static double get badgeSizeLg => 24.w;
  
  // Bottom sheet sizes
  static double get bottomSheetMinHeight => 200.h;
  static double get bottomSheetMidHeight => 400.h;
  static double get bottomSheetMaxHeight => 600.h;
  
  // App bar height
  static double get appBarHeight => 56.h;
  static double get appBarHeightLarge => 80.h;
  
  // Bottom navigation bar height
  static double get bottomNavBarHeight => 56.h;
  
  // Divider thickness
  static double get dividerThin => 0.5;
  static double get dividerRegular => 1.0;
  static double get dividerThick => 2.0;
  
  // Animation durations
  static const Duration animDurationFast = Duration(milliseconds: 150);
  static const Duration animDurationMedium = Duration(milliseconds: 300);
  static const Duration animDurationSlow = Duration(milliseconds: 500);
  
  // Responsive breakpoints
  static const double breakpointMobile = 600;
  static const double breakpointTablet = 1200;
  
  // Helper methods
  static EdgeInsets padding(double value) => EdgeInsets.all(value);
  static EdgeInsets paddingHorizontal(double value) => EdgeInsets.symmetric(horizontal: value);
  static EdgeInsets paddingVertical(double value) => EdgeInsets.symmetric(vertical: value);
  static EdgeInsets paddingOnly({
    double left = 0, 
    double top = 0, 
    double right = 0, 
    double bottom = 0
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
  
  static BorderRadius radius(double value) => BorderRadius.circular(value);
  static BorderRadius radiusOnly({
    double topLeft = 0, 
    double topRight = 0, 
    double bottomLeft = 0, 
    double bottomRight = 0
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft),
    topRight: Radius.circular(topRight),
    bottomLeft: Radius.circular(bottomLeft),
    bottomRight: Radius.circular(bottomRight),
  );
}
