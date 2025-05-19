import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';

/// A standardized transaction item for displaying transaction information.
/// 
/// This widget provides a consistent way to display transaction information with:
/// - Transaction icon based on type
/// - Transaction description
/// - Amount with appropriate color (green for deposits, red for withdrawals)
/// - Date and time
/// - Status indicator
class TransactionItem extends StatelessWidget {
  /// The transaction type (e.g., 'DEPOSIT', 'WITHDRAWAL', 'TRANSFER')
  final String type;
  
  /// The transaction description
  final String description;
  
  /// The transaction amount
  final double amount;
  
  /// The transaction date and time
  final DateTime dateTime;
  
  /// The transaction status (e.g., 'COMPLETED', 'PENDING', 'FAILED')
  final String status;
  
  /// The recipient account number (for transfers)
  final String? recipientAccountNumber;
  
  /// The sender account number (for deposits)
  final String? senderAccountNumber;
  
  /// Callback when the item is tapped
  final VoidCallback? onTap;
  
  /// Whether to show the transaction status
  final bool showStatus;
  
  /// Whether to show the transaction date
  final bool showDate;
  
  /// Whether to show the transaction time
  final bool showTime;
  
  /// Whether to show the transaction type
  final bool showType;
  
  /// The padding for the item content
  final EdgeInsetsGeometry padding;
  
  /// The margin around the item
  final EdgeInsetsGeometry margin;
  
  /// The border radius of the item
  final double borderRadius;
  
  /// Whether to show a divider below the item
  final bool showDivider;
  
  /// The color of the divider
  final Color dividerColor;

  const TransactionItem({
    Key? key,
    required this.type,
    required this.description,
    required this.amount,
    required this.dateTime,
    required this.status,
    this.recipientAccountNumber,
    this.senderAccountNumber,
    this.onTap,
    this.showStatus = true,
    this.showDate = true,
    this.showTime = false,
    this.showType = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 8.0,
    this.showDivider = false,
    this.dividerColor = AppColors.divider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: Container(
            padding: padding,
            margin: margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius.r),
            ),
            child: Row(
              children: [
                _buildTypeIcon(),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          if (showDate || showTime) ...[
                            Text(
                              _formatDateTime(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                          if (showStatus) _buildStatusBadge(theme),
                        ],
                      ),
                      if (recipientAccountNumber != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'Đến: $recipientAccountNumber',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (senderAccountNumber != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'Từ: $senderAccountNumber',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatAmount(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getAmountColor(),
                      ),
                    ),
                    if (showType) ...[
                      SizedBox(height: 4.h),
                      Text(
                        _getTypeText(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: dividerColor,
          ),
      ],
    );
  }

  Widget _buildTypeIcon() {
    IconData iconData;
    Color iconColor;
    Color backgroundColor;
    
    switch (type.toUpperCase()) {
      case 'DEPOSIT':
        iconData = Icons.arrow_downward;
        iconColor = AppColors.deposit;
        backgroundColor = AppColors.deposit.withOpacity(0.1);
        break;
      case 'WITHDRAWAL':
        iconData = Icons.arrow_upward;
        iconColor = AppColors.withdrawal;
        backgroundColor = AppColors.withdrawal.withOpacity(0.1);
        break;
      case 'TRANSFER':
        iconData = Icons.swap_horiz;
        iconColor = AppColors.transfer;
        backgroundColor = AppColors.transfer.withOpacity(0.1);
        break;
      default:
        iconData = Icons.payments;
        iconColor = AppColors.primary;
        backgroundColor = AppColors.primary.withOpacity(0.1);
    }
    
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          iconData,
          color: iconColor,
          size: 20.sp,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ThemeData theme) {
    Color color;
    String text;
    
    switch (status.toUpperCase()) {
      case 'COMPLETED':
      case 'SUCCESS':
        color = AppColors.success;
        text = 'Thành công';
        break;
      case 'PENDING':
        color = AppColors.pending;
        text = 'Đang xử lý';
        break;
      case 'FAILED':
        color = AppColors.failed;
        text = 'Thất bại';
        break;
      case 'DRAFT':
        color = AppColors.draft;
        text = 'Bản nháp';
        break;
      default:
        color = AppColors.info;
        text = status;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDateTime() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final timeFormat = DateFormat('HH:mm');
    
    if (showDate && showTime) {
      return '${dateFormat.format(dateTime)} ${timeFormat.format(dateTime)}';
    } else if (showDate) {
      return dateFormat.format(dateTime);
    } else if (showTime) {
      return timeFormat.format(dateTime);
    }
    
    return '';
  }

  String _formatAmount() {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    
    return formatter.format(amount);
  }

  Color _getAmountColor() {
    switch (type.toUpperCase()) {
      case 'DEPOSIT':
        return AppColors.deposit;
      case 'WITHDRAWAL':
      case 'TRANSFER':
        return AppColors.withdrawal;
      default:
        return AppColors.textPrimary;
    }
  }

  String _getTypeText() {
    switch (type.toUpperCase()) {
      case 'DEPOSIT':
        return 'Nạp tiền';
      case 'WITHDRAWAL':
        return 'Rút tiền';
      case 'TRANSFER':
        return 'Chuyển khoản';
      default:
        return type;
    }
  }
}
