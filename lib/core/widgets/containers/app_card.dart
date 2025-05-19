import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double elevation;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Border? border;
  final double? width;
  final double? height;
  final Clip clipBehavior;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;

  const AppCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 12.0,
    this.elevation = 2.0,
    this.gradient,
    this.onTap,
    this.backgroundColor,
    this.shadowColor,
    this.border,
    this.width,
    this.height,
    this.clipBehavior = Clip.antiAlias,
    this.gradientBegin,
    this.gradientEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardChild = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius.r),
      ),
      child: child,
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius.r),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: (shadowColor ?? Colors.black).withOpacity(0.1),
                  blurRadius: elevation * 2,
                  spreadRadius: elevation / 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: Material(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius.r),
        clipBehavior: clipBehavior,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: cardChild,
        ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double elevation;
  final List<Color> colors;
  final VoidCallback? onTap;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final double? width;
  final double? height;

  const GradientCard({
    Key? key,
    required this.child,
    required this.colors,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 12.0,
    this.elevation = 2.0,
    this.onTap,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      elevation: elevation,
      onTap: onTap,
      width: width,
      height: height,
      gradient: LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
      ),
      backgroundColor: Colors.transparent,
      child: child,
    );
  }
}

class OutlinedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Color borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const OutlinedCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 12.0,
    this.onTap,
    this.borderColor = AppColors.border,
    this.borderWidth = 1.0,
    this.backgroundColor,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      elevation: 0,
      onTap: onTap,
      backgroundColor: backgroundColor ?? AppColors.surface,
      width: width,
      height: height,
      border: Border.all(
        color: borderColor,
        width: borderWidth,
      ),
      child: child,
    );
  }
}
