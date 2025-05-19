import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? bottomBar;
  final Color backgroundColor;
  final Color appBarBackgroundColor;
  final Color appBarForegroundColor;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final double? titleSpacing;
  final double? leadingWidth;
  final bool automaticallyImplyLeading;
  final Widget? flexibleSpace;
  final bool primary;
  final bool? scrolledUnderElevation;
  final Widget? customTitle;

  const AppScaffold({
    Key? key,
    required this.body,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.bottomBar,
    this.backgroundColor = AppColors.background,
    this.appBarBackgroundColor = Colors.white,
    this.appBarForegroundColor = AppColors.textPrimary,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.extendBody = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.onBackPressed,
    this.centerTitle = true,
    this.systemUiOverlayStyle,
    this.leading,
    this.bottom,
    this.elevation,
    this.titleSpacing,
    this.leadingWidth,
    this.automaticallyImplyLeading = true,
    this.flexibleSpace,
    this.primary = true,
    this.scrolledUnderElevation,
    this.customTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasAppBar = title != null || customTitle != null || actions != null || showBackButton;

    return Scaffold(
      appBar: hasAppBar
          ? AppBar(
              title: customTitle ?? (title != null ? Text(title!) : null),
              centerTitle: centerTitle,
              backgroundColor: appBarBackgroundColor,
              foregroundColor: appBarForegroundColor,
              elevation: elevation,
              systemOverlayStyle: systemUiOverlayStyle ??
                  SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: _isDark(appBarBackgroundColor)
                        ? Brightness.light
                        : Brightness.dark,
                    statusBarBrightness: _isDark(appBarBackgroundColor)
                        ? Brightness.dark
                        : Brightness.light,
                  ),
              leading: leading ??
                  (showBackButton
                      ? IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: onBackPressed ??
                              () {
                                Navigator.of(context).pop();
                              },
                        )
                      : null),
              actions: actions,
              bottom: bottom,
              titleSpacing: titleSpacing,
              leadingWidth: leadingWidth,
              automaticallyImplyLeading: automaticallyImplyLeading,
              flexibleSpace: flexibleSpace,
              primary: primary,
             // scrolledUnderElevation: scrolledUnderElevation,
            )
          : null,
      body: body,
      backgroundColor: backgroundColor,
      bottomNavigationBar: bottomBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      extendBody: extendBody,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
    );
  }

  bool _isDark(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.dark;
  }
}

class AppBarAction {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;
  final double? size;

  const AppBarAction({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.size,
  });

  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: color,
        size: size ?? 24.sp,
      ),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }
}

class AppBarTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? leading;
  final double? spacing;

  const AppBarTitle({
    Key? key,
    required this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.leading,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leading != null) ...[
          leading!,
          SizedBox(width: spacing ?? 8.w),
        ],
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle ??
                    theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null) ...[
                SizedBox(height: 2.h),
                Text(
                  subtitle!,
                  style: subtitleStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
