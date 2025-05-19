import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../buttons/app_button.dart';
import '../buttons/button_type.dart';

class AppBottomSheet extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final bool isDismissible;
  final double? maxHeight;
  final bool isScrollable;
  final bool showDragHandle;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final double borderRadius;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const AppBottomSheet({
    Key? key,
    this.title,
    required this.content,
    this.actions,
    this.isDismissible = true,
    this.maxHeight,
    this.isScrollable = true,
    this.showDragHandle = true,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = Colors.white,
    this.borderRadius = 16.0,
    this.showCloseButton = false,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius.r),
          topRight: Radius.circular(borderRadius.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) ...[
            SizedBox(height: 8.h),
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
          ],
          if (title != null || showCloseButton) ...[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  if (showCloseButton)
                    IconButton(
                      icon: Icon(Icons.close, size: 24.sp),
                      onPressed: () {
                        if (onClose != null) {
                          onClose!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
            Divider(height: 1.h, thickness: 1.h, color: AppColors.divider),
          ],
          isScrollable
              ? Flexible(
                  child: SingleChildScrollView(
                    padding: padding,
                    child: content,
                  ),
                )
              : Padding(
                  padding: padding,
                  child: content,
                ),
          if (actions != null && actions!.isNotEmpty) ...[
            Divider(height: 1.h, thickness: 1.h, color: AppColors.divider),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!
                    .map((action) => Padding(
                          padding: EdgeInsets.only(left: 8.w),
                          child: action,
                        ))
                    .toList(),
              ),
            ),
          ],
          // Add extra padding at the bottom for devices with rounded corners
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    bool isDismissible = true,
    bool enableDrag = true,
    double? maxHeight,
    bool isScrollable = true,
    bool showDragHandle = true,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
    Color backgroundColor = Colors.white,
    double borderRadius = 16.0,
    bool showCloseButton = false,
    VoidCallback? onClose,
    bool useRootNavigator = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: useRootNavigator,
      builder: (context) => AppBottomSheet(
        title: title,
        content: content,
        actions: actions,
        isDismissible: isDismissible,
        maxHeight: maxHeight,
        isScrollable: isScrollable,
        showDragHandle: showDragHandle,
        padding: padding,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        showCloseButton: showCloseButton,
        onClose: onClose,
      ),
    );
  }
}

class AppActionBottomSheet extends StatelessWidget {
  final String? title;
  final String? message;
  final List<BottomSheetAction> actions;
  final bool isDismissible;
  final bool showCancelButton;
  final String cancelButtonText;
  final VoidCallback? onCancel;
  final double? maxHeight;
  final bool isScrollable;
  final EdgeInsetsGeometry padding;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const AppActionBottomSheet({
    Key? key,
    this.title,
    this.message,
    required this.actions,
    this.isDismissible = true,
    this.showCancelButton = true,
    this.cancelButtonText = 'Hủy',
    this.onCancel,
    this.maxHeight,
    this.isScrollable = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.titleStyle,
    this.messageStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      title: title,
      isDismissible: isDismissible,
      maxHeight: maxHeight,
      isScrollable: isScrollable,
      padding: padding,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message != null) ...[
            Text(
              message!,
              style: messageStyle ??
                  TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
            ),
            SizedBox(height: 16.h),
          ],
          ...actions.map((action) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _buildActionButton(context, action),
              )),
          if (showCancelButton) ...[
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: cancelButtonText,
                buttonType: ButtonType.outline,
                onPressed: () {
                  if (onCancel != null) {
                    onCancel!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, BottomSheetAction action) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        text: action.title,
        buttonType: action.isDestructive ? ButtonType.secondary : ButtonType.primary,
        onPressed: () {
          Navigator.of(context).pop();
          if (action.onPressed != null) {
            action.onPressed!();
          }
        },
        icon: action.icon,
        iconPosition: action.iconPosition,
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? message,
    required List<BottomSheetAction> actions,
    bool isDismissible = true,
    bool showCancelButton = true,
    String cancelButtonText = 'Hủy',
    VoidCallback? onCancel,
    double? maxHeight,
    bool isScrollable = true,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    bool useRootNavigator = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: useRootNavigator,
      builder: (context) => AppActionBottomSheet(
        title: title,
        message: message,
        actions: actions,
        isDismissible: isDismissible,
        showCancelButton: showCancelButton,
        cancelButtonText: cancelButtonText,
        onCancel: onCancel,
        maxHeight: maxHeight,
        isScrollable: isScrollable,
        padding: padding,
        titleStyle: titleStyle,
        messageStyle: messageStyle,
      ),
    );
  }
}

class BottomSheetAction {
  final String title;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool isDestructive;

  BottomSheetAction({
    required this.title,
    this.onPressed,
    this.icon,
    this.iconPosition = IconPosition.left,
    this.isDestructive = false,
  });
}
