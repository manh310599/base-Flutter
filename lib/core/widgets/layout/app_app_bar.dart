import 'package:flutter/material.dart';
import 'package:base_project2/core/theme/app_colors.dart';

/// A custom app bar that can be used throughout the application.
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? titleColor;
  final double elevation;
  final bool automaticallyImplyLeading;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? titleSpacing;
  final double? leadingWidth;
  final TextStyle? titleTextStyle;
  final bool? primary;
  final double? toolbarHeight;
  final ShapeBorder? shape;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final VoidCallback? onBackPressed;

  const AppAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.titleColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.flexibleSpace,
    this.bottom,
    this.titleSpacing,
    this.leadingWidth,
    this.titleTextStyle,
    this.primary,
    this.toolbarHeight,
    this.shape,
    this.iconTheme,
    this.actionsIconTheme,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: titleTextStyle ??
            TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: titleColor ?? AppColors.textPrimary,
            ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ??
          (automaticallyImplyLeading && Navigator.of(context).canPop()
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  color: titleColor ?? AppColors.textPrimary,
                )
              : null),
      actions: actions,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      primary: primary ?? true,
      toolbarHeight: toolbarHeight,
      shape: shape,
      iconTheme: iconTheme ??
          IconThemeData(
            color: titleColor ?? AppColors.textPrimary,
          ),
      actionsIconTheme: actionsIconTheme ??
          IconThemeData(
            color: titleColor ?? AppColors.textPrimary,
          ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  /// Creates an app bar with a transparent background.
  factory AppAppBar.transparent({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    Color? titleColor,
    VoidCallback? onBackPressed,
  }) {
    return AppAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      titleColor: titleColor ?? Colors.white,
      elevation: 0,
      onBackPressed: onBackPressed,
    );
  }

  /// Creates an app bar with a primary color background.
  factory AppAppBar.primary({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    VoidCallback? onBackPressed,
  }) {
    return AppAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: AppColors.primary,
      titleColor: Colors.white,
      elevation: 0,
      onBackPressed: onBackPressed,
    );
  }

  /// Creates an app bar with a search field.
  factory AppAppBar.search({
    required String hint,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    VoidCallback? onClear,
    List<Widget>? actions,
    Widget? leading,
    Color? backgroundColor,
    VoidCallback? onBackPressed,
  }) {
    return AppAppBar(
      title: '',
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: onBackPressed,
            color: AppColors.textPrimary,
          ),
      titleSpacing: 0,
      actions: actions,
      flexibleSpace: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textHint,
              fontSize: 16,
            ),
            border: InputBorder.none,
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                      onChanged('');
                      onClear?.call();
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
