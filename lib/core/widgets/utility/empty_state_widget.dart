import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../buttons/app_button.dart';
import '../buttons/button_type.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Widget? action;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryActionPressed;
  final EdgeInsetsGeometry padding;
  final Widget? customIcon;
  final TextStyle? messageStyle;
  final TextStyle? actionTextStyle;
  final ButtonType actionButtonType;
  final ButtonType secondaryActionButtonType;
  final double? iconSize;
  final Color? iconColor;
  final String? title;
  final TextStyle? titleStyle;
  final bool isCompact;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.icon,
    this.action,
    this.actionText,
    this.onActionPressed,
    this.secondaryActionText,
    this.onSecondaryActionPressed,
    this.padding = const EdgeInsets.all(16),
    this.customIcon,
    this.messageStyle,
    this.actionTextStyle,
    this.actionButtonType = ButtonType.primary,
    this.secondaryActionButtonType = ButtonType.outline,
    this.iconSize,
    this.iconColor,
    this.title,
    this.titleStyle,
    this.isCompact = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isCompact) {
      return Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (customIcon != null) ...[
              customIcon!,
              SizedBox(width: 16.w),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: iconSize ?? 24.sp,
                color: iconColor ?? AppColors.textSecondary,
              ),
              SizedBox(width: 16.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: titleStyle ??
                          theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  Text(
                    message,
                    style: messageStyle ??
                        theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            if (action != null) ...[
              SizedBox(width: 16.w),
              action!,
            ] else if (actionText != null && onActionPressed != null) ...[
              SizedBox(width: 16.w),
              TextButton(
                onPressed: onActionPressed,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      );
    }
    
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (customIcon != null) ...[
            customIcon!,
            SizedBox(height: 16.h),
          ] else if (icon != null) ...[
            Icon(
              icon,
              size: iconSize ?? 64.sp,
              color: iconColor ?? AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
          ],
          if (title != null) ...[
            Text(
              title!,
              style: titleStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
          ],
          Text(
            message,
            style: messageStyle ??
                theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          if (action != null) ...[
            action!,
          ] else if (actionText != null && onActionPressed != null) ...[
            AppButton(
              text: actionText!,
              onPressed: onActionPressed,
              buttonType: actionButtonType,
            ),
          ],
          if (secondaryActionText != null && onSecondaryActionPressed != null) ...[
            SizedBox(height: 12.h),
            AppButton(
              text: secondaryActionText!,
              onPressed: onSecondaryActionPressed,
              buttonType: secondaryActionButtonType,
            ),
          ],
        ],
      ),
    );
  }
}

class NoDataWidget extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool isCompact;

  const NoDataWidget({
    Key? key,
    this.message = 'Không có dữ liệu',
    this.actionText,
    this.onActionPressed,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      message: message,
      icon: Icons.inbox,
      actionText: actionText,
      onActionPressed: onActionPressed,
      isCompact: isCompact,
    );
  }
}

class NoResultsWidget extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool isCompact;

  const NoResultsWidget({
    Key? key,
    this.message = 'Không tìm thấy kết quả',
    this.actionText,
    this.onActionPressed,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      message: message,
      icon: Icons.search_off,
      actionText: actionText,
      onActionPressed: onActionPressed,
      isCompact: isCompact,
    );
  }
}

class NoTransactionsWidget extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool isCompact;

  const NoTransactionsWidget({
    Key? key,
    this.message = 'Bạn chưa có giao dịch nào',
    this.actionText = 'Tạo giao dịch mới',
    this.onActionPressed,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      message: message,
      icon: Icons.receipt_long,
      actionText: actionText,
      onActionPressed: onActionPressed,
      isCompact: isCompact,
    );
  }
}

class NoBeneficiariesWidget extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool isCompact;

  const NoBeneficiariesWidget({
    Key? key,
    this.message = 'Bạn chưa có người thụ hưởng nào',
    this.actionText = 'Thêm người thụ hưởng',
    this.onActionPressed,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      message: message,
      icon: Icons.people,
      actionText: actionText,
      onActionPressed: onActionPressed,
      isCompact: isCompact,
    );
  }
}
