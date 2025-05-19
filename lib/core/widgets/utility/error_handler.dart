import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../buttons/app_button.dart';
import '../buttons/button_type.dart';

class ErrorHandler extends StatelessWidget {
  final dynamic error;
  final VoidCallback? onRetry;
  final String retryButtonText;
  final String? title;
  final String? message;
  final Widget? icon;
  final bool showHomeButton;
  final VoidCallback? onHomePressed;
  final String homeButtonText;
  final EdgeInsetsGeometry padding;
  final bool showIcon;
  final bool showDetails;
  final bool isCompact;

  const ErrorHandler({
    Key? key,
    required this.error,
    this.onRetry,
    this.retryButtonText = 'Thử lại',
    this.title,
    this.message,
    this.icon,
    this.showHomeButton = false,
    this.onHomePressed,
    this.homeButtonText = 'Về trang chủ',
    this.padding = const EdgeInsets.all(16),
    this.showIcon = true,
    this.showDetails = false,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final errorMessage = message ?? _getErrorMessage(error);
    final errorTitle = title ?? 'Đã xảy ra lỗi';
    
    if (isCompact) {
      return Padding(
        padding: padding,
        child: Row(
          children: [
            if (showIcon) ...[
              icon ??
                  Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 24.sp,
                  ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    errorTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    errorMessage,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(width: 12.w),
              TextButton(
                onPressed: onRetry,
                child: Text(retryButtonText),
              ),
            ],
          ],
        ),
      );
    }
    
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showIcon) ...[
            icon ??
                Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 64.sp,
                ),
            SizedBox(height: 16.h),
          ],
          Text(
            errorTitle,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            errorMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (showDetails && error != null) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                error.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
          SizedBox(height: 24.h),
          if (onRetry != null)
            AppButton(
              text: retryButtonText,
              onPressed: onRetry,
              icon: Icons.refresh,
            ),
          if (showHomeButton && onHomePressed != null) ...[
            SizedBox(height: 12.h),
            AppButton(
              text: homeButtonText,
              onPressed: onHomePressed,
              buttonType: ButtonType.outline,
              icon: Icons.home,
            ),
          ],
        ],
      ),
    );
  }

  String _getErrorMessage(dynamic error) {
    if (error == null) {
      return 'Đã xảy ra lỗi không xác định';
    }
    
    if (error is String) {
      return error;
    }
    
    // Handle common error types
    if (error.toString().contains('SocketException') ||
        error.toString().contains('Connection refused') ||
        error.toString().contains('Network is unreachable')) {
      return 'Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối mạng và thử lại.';
    }
    
    if (error.toString().contains('timed out')) {
      return 'Yêu cầu đã hết thời gian chờ. Vui lòng thử lại sau.';
    }
    
    if (error.toString().contains('404')) {
      return 'Không tìm thấy tài nguyên yêu cầu.';
    }
    
    if (error.toString().contains('500')) {
      return 'Máy chủ gặp lỗi. Vui lòng thử lại sau.';
    }
    
    if (error.toString().contains('401') || error.toString().contains('403')) {
      return 'Bạn không có quyền truy cập. Vui lòng đăng nhập lại.';
    }
    
    return 'Đã xảy ra lỗi. Vui lòng thử lại sau.';
  }
}

class ApiErrorWidget extends StatelessWidget {
  final dynamic apiError;
  final VoidCallback? onRetry;
  final String retryButtonText;
  final bool showHomeButton;
  final VoidCallback? onHomePressed;
  final String homeButtonText;
  final EdgeInsetsGeometry padding;
  final bool showIcon;
  final bool isCompact;

  const ApiErrorWidget({
    Key? key,
    required this.apiError,
    this.onRetry,
    this.retryButtonText = 'Thử lại',
    this.showHomeButton = false,
    this.onHomePressed,
    this.homeButtonText = 'Về trang chủ',
    this.padding = const EdgeInsets.all(16),
    this.showIcon = true,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Extract error information from ApiError
    final String errorMessage = _getErrorMessage();
    final String errorTitle = _getErrorTitle();
    
    return ErrorHandler(
      error: apiError,
      onRetry: onRetry,
      retryButtonText: retryButtonText,
      title: errorTitle,
      message: errorMessage,
      showHomeButton: showHomeButton,
      onHomePressed: onHomePressed,
      homeButtonText: homeButtonText,
      padding: padding,
      showIcon: showIcon,
      isCompact: isCompact,
    );
  }

  String _getErrorMessage() {
    // In a real app, you would extract the message from your ApiError type
    if (apiError == null) {
      return 'Đã xảy ra lỗi không xác định';
    }
    
    if (apiError is String) {
      return apiError;
    }
    
    // Example of extracting message from a hypothetical ApiError class
    if (apiError.message != null) {
      return apiError.message;
    }
    
    return 'Đã xảy ra lỗi. Vui lòng thử lại sau.';
  }

  String _getErrorTitle() {
    // In a real app, you would extract the title from your ApiError type
    if (apiError == null) {
      return 'Đã xảy ra lỗi';
    }
    
    // Example of extracting title based on error code
    if (apiError.statusCode != null) {
      final statusCode = apiError.statusCode;
      
      if (statusCode == 401 || statusCode == 403) {
        return 'Lỗi xác thực';
      }
      
      if (statusCode == 404) {
        return 'Không tìm thấy';
      }
      
      if (statusCode >= 500) {
        return 'Lỗi máy chủ';
      }
    }
    
    return 'Đã xảy ra lỗi';
  }
}
