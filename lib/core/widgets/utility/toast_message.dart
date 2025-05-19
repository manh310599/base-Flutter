import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

enum ToastType {
  success,
  error,
  warning,
  info,
}

class ToastMessage extends StatelessWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showIcon;
  final IconData? icon;
  final bool dismissible;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? messageStyle;
  final TextStyle? actionStyle;

  const ToastMessage({
    Key? key,
    required this.message,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.showIcon = true,
    this.icon,
    this.dismissible = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.textColor,
    this.messageStyle,
    this.actionStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final Color bgColor = backgroundColor ?? _getBackgroundColor();
    final Color txtColor = textColor ?? _getTextColor();
    
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (showIcon) ...[
              Icon(
                icon ?? _getIcon(),
                color: txtColor,
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Text(
                message,
                style: messageStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      color: txtColor,
                    ),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(width: 8.w),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: txtColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: const Size(0, 0),
                ),
                child: Text(
                  actionLabel!,
                  style: actionStyle ??
                      TextStyle(
                        color: txtColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
            if (dismissible) ...[
              SizedBox(width: 4.w),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: txtColor,
                  size: 16.sp,
                ),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                splashRadius: 16.r,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ToastType.success:
        return AppColors.success.withOpacity(0.9);
      case ToastType.error:
        return AppColors.error.withOpacity(0.9);
      case ToastType.warning:
        return AppColors.warning.withOpacity(0.9);
      case ToastType.info:
        return AppColors.info.withOpacity(0.9);
    }
  }

  Color _getTextColor() {
    switch (type) {
      case ToastType.success:
      case ToastType.error:
      case ToastType.info:
        return Colors.white;
      case ToastType.warning:
        return Colors.black87;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
    }
  }

  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool showIcon = true,
    IconData? icon,
    bool dismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    double borderRadius = 8.0,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? messageStyle,
    TextStyle? actionStyle,
    bool removeCurrentToast = true,
    bool showAtTop = false,
  }) {
    if (removeCurrentToast) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ToastMessage(
          message: message,
          type: type,
          duration: duration,
          onDismiss: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          actionLabel: actionLabel,
          onAction: onAction,
          showIcon: showIcon,
          icon: icon,
          dismissible: dismissible,
          padding: padding,
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          textColor: textColor,
          messageStyle: messageStyle,
          actionStyle: actionStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        margin: EdgeInsets.all(16.r),
        padding: EdgeInsets.zero,
        dismissDirection: DismissDirection.horizontal,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: '',
                onPressed: () {},
                textColor: Colors.transparent,
              )
            : null,
      ),
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.success,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.error,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context: context,
      message: message,
      type: ToastType.info,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

class ToastOverlay extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool showIcon;
  final IconData? icon;
  final bool dismissible;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final TextStyle? messageStyle;
  final TextStyle? actionStyle;
  final bool autoDismiss;
  final Alignment alignment;
  final double? width;
  final double? maxWidth;

  const ToastOverlay({
    Key? key,
    required this.message,
    this.type = ToastType.info,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.showIcon = true,
    this.icon,
    this.dismissible = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.textColor,
    this.messageStyle,
    this.actionStyle,
    this.autoDismiss = true,
    this.alignment = Alignment.bottomCenter,
    this.width,
    this.maxWidth,
  }) : super(key: key);

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();

  static OverlayEntry? _currentOverlay;

  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    VoidCallback? onDismiss,
    String? actionLabel,
    VoidCallback? onAction,
    bool showIcon = true,
    IconData? icon,
    bool dismissible = true,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    double borderRadius = 8.0,
    Color? backgroundColor,
    Color? textColor,
    TextStyle? messageStyle,
    TextStyle? actionStyle,
    bool autoDismiss = true,
    Alignment alignment = Alignment.bottomCenter,
    double? width,
    double? maxWidth,
  }) {
    hide(); // Hide any existing toast
    
    _currentOverlay = OverlayEntry(
      builder: (context) => ToastOverlay(
        message: message,
        type: type,
        duration: duration,
        onDismiss: () {
          hide();
          if (onDismiss != null) {
            onDismiss();
          }
        },
        actionLabel: actionLabel,
        onAction: onAction,
        showIcon: showIcon,
        icon: icon,
        dismissible: dismissible,
        padding: padding,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        textColor: textColor,
        messageStyle: messageStyle,
        actionStyle: actionStyle,
        autoDismiss: autoDismiss,
        alignment: alignment,
        width: width,
        maxWidth: maxWidth,
      ),
    );
    
    Overlay.of(context).insert(_currentOverlay!);
  }

  static void hide() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

class _ToastOverlayState extends State<ToastOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    
    _controller.forward();
    
    if (widget.autoDismiss) {
      Future.delayed(widget.duration, () {
        if (mounted) {
          _dismiss();
        }
      });
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _dismiss() {
    _controller.reverse().then((_) {
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !widget.dismissible,
        child: GestureDetector(
          onTap: widget.dismissible ? _dismiss : null,
          behavior: HitTestBehavior.translucent,
          child: Align(
            alignment: widget.alignment,
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: FadeTransition(
                opacity: _animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(_animation),
                  child: Container(
                    width: widget.width,
                    constraints: BoxConstraints(
                      maxWidth: widget.maxWidth ?? 400.w,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: ToastMessage(
                        message: widget.message,
                        type: widget.type,
                        duration: widget.duration,
                        onDismiss: _dismiss,
                        actionLabel: widget.actionLabel,
                        onAction: widget.onAction,
                        showIcon: widget.showIcon,
                        icon: widget.icon,
                        dismissible: widget.dismissible,
                        padding: widget.padding,
                        borderRadius: widget.borderRadius,
                        backgroundColor: widget.backgroundColor,
                        textColor: widget.textColor,
                        messageStyle: widget.messageStyle,
                        actionStyle: widget.actionStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
