import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isSelected;
  final EdgeInsetsGeometry padding;
  final double? height;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool dense;
  final bool enabled;
  final bool showDivider;
  final Color dividerColor;
  final double dividerHeight;
  final double dividerIndent;
  final double dividerEndIndent;

  const AppListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.height,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderRadius,
    this.border,
    this.titleStyle,
    this.subtitleStyle,
    this.dense = false,
    this.enabled = true,
    this.showDivider = false,
    this.dividerColor = AppColors.divider,
    this.dividerHeight = 1.0,
    this.dividerIndent = 0.0,
    this.dividerEndIndent = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final defaultTitleStyle = theme.textTheme.bodyLarge?.copyWith(
      color: enabled ? AppColors.textPrimary : AppColors.textDisabled,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
    );
    
    final defaultSubtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: enabled ? AppColors.textSecondary : AppColors.textDisabled,
    );
    
    final effectiveBackgroundColor = isSelected
        ? selectedBackgroundColor ?? AppColors.primary.withOpacity(0.1)
        : backgroundColor ?? Colors.transparent;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: effectiveBackgroundColor,
            borderRadius: borderRadius,
            border: border,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: enabled ? onTap : null,
              borderRadius: borderRadius,
              child: Padding(
                padding: padding,
                child: Row(
                  children: [
                    if (leading != null) ...[
                      leading!,
                      SizedBox(width: 16.w),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: titleStyle ?? defaultTitleStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              subtitle!,
                              style: subtitleStyle ?? defaultSubtitleStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...[
                      SizedBox(width: 16.w),
                      trailing!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: dividerHeight.h,
            thickness: dividerHeight.h,
            color: dividerColor,
            indent: dividerIndent.w,
            endIndent: dividerEndIndent.w,
          ),
      ],
    );
  }
}

class AppSelectionTile<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final EdgeInsetsGeometry padding;
  final double? height;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool dense;
  final bool enabled;
  final bool showDivider;
  final Color dividerColor;
  final double dividerHeight;
  final double dividerIndent;
  final double dividerEndIndent;
  final Widget Function(bool isSelected)? customTrailing;

  const AppSelectionTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.height,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderRadius,
    this.border,
    this.titleStyle,
    this.subtitleStyle,
    this.dense = false,
    this.enabled = true,
    this.showDivider = false,
    this.dividerColor = AppColors.divider,
    this.dividerHeight = 1.0,
    this.dividerIndent = 0.0,
    this.dividerEndIndent = 0.0,
    this.customTrailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    
    return AppListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: customTrailing != null
          ? customTrailing!(isSelected)
          : Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: enabled ? onChanged : null,
              activeColor: AppColors.primary,
            ),
      onTap: enabled
          ? () {
              onChanged?.call(value);
            }
          : null,
      isSelected: isSelected,
      padding: padding,
      height: height,
      backgroundColor: backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      borderRadius: borderRadius,
      border: border,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      dense: dense,
      enabled: enabled,
      showDivider: showDivider,
      dividerColor: dividerColor,
      dividerHeight: dividerHeight,
      dividerIndent: dividerIndent,
      dividerEndIndent: dividerEndIndent,
    );
  }
}

class AppCheckboxTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final EdgeInsetsGeometry padding;
  final double? height;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final BorderRadius? borderRadius;
  final Border? border;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool dense;
  final bool enabled;
  final bool showDivider;
  final Color dividerColor;
  final double dividerHeight;
  final double dividerIndent;
  final double dividerEndIndent;
  final Widget Function(bool isSelected)? customTrailing;

  const AppCheckboxTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.height,
    this.backgroundColor,
    this.selectedBackgroundColor,
    this.borderRadius,
    this.border,
    this.titleStyle,
    this.subtitleStyle,
    this.dense = false,
    this.enabled = true,
    this.showDivider = false,
    this.dividerColor = AppColors.divider,
    this.dividerHeight = 1.0,
    this.dividerIndent = 0.0,
    this.dividerEndIndent = 0.0,
    this.customTrailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: customTrailing != null
          ? customTrailing!(value)
          : Checkbox(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: AppColors.primary,
            ),
      onTap: enabled
          ? () {
              onChanged?.call(!value);
            }
          : null,
      isSelected: value,
      padding: padding,
      height: height,
      backgroundColor: backgroundColor,
      selectedBackgroundColor: selectedBackgroundColor,
      borderRadius: borderRadius,
      border: border,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      dense: dense,
      enabled: enabled,
      showDivider: showDivider,
      dividerColor: dividerColor,
      dividerHeight: dividerHeight,
      dividerIndent: dividerIndent,
      dividerEndIndent: dividerEndIndent,
    );
  }
}
