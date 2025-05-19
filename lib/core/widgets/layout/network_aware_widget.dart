import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../network/connectivity_service.dart';
import '../../theme/app_colors.dart';
import '../buttons/app_button.dart';

class NetworkAwareWidget extends StatelessWidget {
  final Widget onlineChild;
  final Widget? offlineChild;
  final NetworkStatus networkStatus;
  final bool showOfflineMessage;
  final String offlineMessage;
  final VoidCallback? onRetry;
  final bool showRetryButton;
  final String retryButtonText;
  final bool showCellularWarning;
  final String cellularWarningMessage;

  const NetworkAwareWidget({
    Key? key,
    required this.onlineChild,
    this.offlineChild,
    required this.networkStatus,
    this.showOfflineMessage = true,
    this.offlineMessage = 'Không có kết nối mạng',
    this.onRetry,
    this.showRetryButton = true,
    this.retryButtonText = 'Thử lại',
    this.showCellularWarning = false,
    this.cellularWarningMessage = 'Đang sử dụng dữ liệu di động',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (networkStatus == NetworkStatus.online) {
      return onlineChild;
    } else if (networkStatus == NetworkStatus.cellular && showCellularWarning) {
      return Column(
        children: [
          _buildCellularWarning(),
          Expanded(child: onlineChild),
        ],
      );
    } else if (networkStatus == NetworkStatus.offline) {
      return offlineChild ?? _buildOfflineWidget(context);
    }

    // Default fallback
    return onlineChild;
  }

  Widget _buildOfflineWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 64.sp,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16.h),
            if (showOfflineMessage) ...[
              Text(
                offlineMessage,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                'Vui lòng kiểm tra kết nối mạng và thử lại',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
            ],
            if (showRetryButton && onRetry != null)
              AppButton(
                text: retryButtonText,
                onPressed: onRetry,
                icon: Icons.refresh,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCellularWarning() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      color: AppColors.warning.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.signal_cellular_alt,
            color: AppColors.warning,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              cellularWarningMessage,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NetworkStatusBanner extends StatelessWidget {
  final NetworkStatus networkStatus;
  final VoidCallback? onRetry;
  final bool showOnCellular;
  final String offlineMessage;
  final String cellularMessage;
  final String onlineMessage;
  final bool showOnline;
  final Duration autoDismissDuration;
  final bool autoDismiss;

  const NetworkStatusBanner({
    Key? key,
    required this.networkStatus,
    this.onRetry,
    this.showOnCellular = true,
    this.offlineMessage = 'Không có kết nối mạng',
    this.cellularMessage = 'Đang sử dụng dữ liệu di động',
    this.onlineMessage = 'Đã kết nối mạng',
    this.showOnline = false,
    this.autoDismissDuration = const Duration(seconds: 3),
    this.autoDismiss = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (networkStatus == NetworkStatus.offline) {
      return _buildBanner(
        context,
        message: offlineMessage,
        icon: Icons.wifi_off,
        backgroundColor: AppColors.error.withOpacity(0.1),
        iconColor: AppColors.error,
        showRetry: true,
      );
    } else if (networkStatus == NetworkStatus.cellular && showOnCellular) {
      return _buildBanner(
        context,
        message: cellularMessage,
        icon: Icons.signal_cellular_alt,
        backgroundColor: AppColors.warning.withOpacity(0.1),
        iconColor: AppColors.warning,
        showRetry: false,
      );
    } else if (networkStatus == NetworkStatus.online && showOnline) {
      return _buildBanner(
        context,
        message: onlineMessage,
        icon: Icons.wifi,
        backgroundColor: AppColors.success.withOpacity(0.1),
        iconColor: AppColors.success,
        showRetry: false,
        autoDismiss: autoDismiss,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBanner(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required bool showRetry,
    bool? autoDismiss,
  }) {
    final banner = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 8.h,
      ),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20.sp,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (showRetry && onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Thử lại',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );

    if (autoDismiss ?? this.autoDismiss) {
      return _AutoDismissBanner(
        duration: autoDismissDuration,
        child: banner,
      );
    }

    return banner;
  }
}

class _AutoDismissBanner extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const _AutoDismissBanner({
    Key? key,
    required this.child,
    required this.duration,
  }) : super(key: key);

  @override
  State<_AutoDismissBanner> createState() => _AutoDismissBannerState();
}

class _AutoDismissBannerState extends State<_AutoDismissBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          // This callback might be called after the widget is disposed
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SizeTransition(
        sizeFactor: _animation,
        axisAlignment: -1.0,
        child: widget.child,
      ),
    );
  }
}
