import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import '../buttons/app_button.dart';
import '../buttons/button_type.dart';

class DateRangePicker extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final ValueChanged<DateTimeRange>? onDateRangeChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? title;
  final String? startDateLabel;
  final String? endDateLabel;
  final String? cancelButtonText;
  final String? confirmButtonText;
  final String? resetButtonText;
  final bool showResetButton;
  final bool showActionButtons;
  final bool showHeader;
  final bool compact;
  final DateFormat? dateFormat;
  final bool allowSameDay;
  final bool showCalendarIcon;
  final bool showDivider;
  final EdgeInsetsGeometry padding;
  final BoxDecoration? decoration;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final Color? activeColor;
  final bool enabled;

  const DateRangePicker({
    Key? key,
    this.initialDateRange,
    this.onDateRangeChanged,
    this.firstDate,
    this.lastDate,
    this.title,
    this.startDateLabel = 'Từ ngày',
    this.endDateLabel = 'Đến ngày',
    this.cancelButtonText = 'Hủy',
    this.confirmButtonText = 'Xác nhận',
    this.resetButtonText = 'Đặt lại',
    this.showResetButton = true,
    this.showActionButtons = true,
    this.showHeader = true,
    this.compact = false,
    this.dateFormat,
    this.allowSameDay = true,
    this.showCalendarIcon = true,
    this.showDivider = true,
    this.padding = const EdgeInsets.all(16),
    this.decoration,
    this.labelStyle,
    this.valueStyle,
    this.activeColor,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late DateTimeRange? _selectedDateRange;
  final DateFormat _defaultDateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.initialDateRange;
  }

  @override
  void didUpdateWidget(DateRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDateRange != oldWidget.initialDateRange) {
      _selectedDateRange = widget.initialDateRange;
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    if (!widget.enabled) return;

    final now = DateTime.now();
    final firstDate = widget.firstDate ?? DateTime(now.year - 5, now.month, now.day);
    final lastDate = widget.lastDate ?? DateTime(now.year + 5, now.month, now.day);

    final initialDateRange = _selectedDateRange ??
        DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );

    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.activeColor ?? AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: widget.activeColor ?? AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        _selectedDateRange = pickedDateRange;
      });

      if (widget.onDateRangeChanged != null) {
        widget.onDateRangeChanged!(pickedDateRange);
      }
    }
  }

  void _resetDateRange() {
    setState(() {
      _selectedDateRange = null;
    });

    if (widget.onDateRangeChanged != null) {
      widget.onDateRangeChanged!(
        DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 7)),
          end: DateTime.now(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = widget.dateFormat ?? _defaultDateFormat;

    final startDateText = _selectedDateRange != null
        ? dateFormat.format(_selectedDateRange!.start)
        : '-- / -- / ----';

    final endDateText = _selectedDateRange != null
        ? dateFormat.format(_selectedDateRange!.end)
        : '-- / -- / ----';

    final defaultDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: AppColors.border,
        width: 1,
      ),
    );

    if (widget.compact) {
      return GestureDetector(
        onTap: () => _selectDateRange(context),
        child: Container(
          padding: widget.padding,
          decoration: widget.decoration ?? defaultDecoration,
          child: Row(
            children: [
              if (widget.showCalendarIcon) ...[
                Icon(
                  Icons.date_range,
                  color: widget.enabled
                      ? (widget.activeColor ?? AppColors.primary)
                      : AppColors.textDisabled,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
              ],
              Expanded(
                child: Text(
                  '$startDateText - $endDateText',
                  style: widget.valueStyle ??
                      theme.textTheme.bodyMedium?.copyWith(
                        color: widget.enabled
                            ? AppColors.textPrimary
                            : AppColors.textDisabled,
                      ),
                ),
              ),
              if (widget.enabled)
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: widget.padding,
      decoration: widget.decoration ?? defaultDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeader && widget.title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.showResetButton)
                  TextButton(
                    onPressed: widget.enabled ? _resetDateRange : null,
                    child: Text(
                      widget.resetButtonText!,
                      style: TextStyle(
                        color: widget.enabled
                            ? (widget.activeColor ?? AppColors.primary)
                            : AppColors.textDisabled,
                      ),
                    ),
                  ),
              ],
            ),
            if (widget.showDivider)
              Divider(
                height: 16.h,
                thickness: 1,
                color: AppColors.divider,
              ),
          ],
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  context,
                  label: widget.startDateLabel!,
                  value: startDateText,
                  onTap: () => _selectDateRange(context),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildDateField(
                  context,
                  label: widget.endDateLabel!,
                  value: endDateText,
                  onTap: () => _selectDateRange(context),
                ),
              ),
            ],
          ),
          if (widget.showActionButtons) ...[
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: widget.cancelButtonText!,
                  buttonType: ButtonType.outline,
                  onPressed: widget.enabled
                      ? () {
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
                SizedBox(width: 8.w),
                AppButton(
                  text: widget.confirmButtonText!,
                  onPressed: widget.enabled && _selectedDateRange != null
                      ? () {
                          if (widget.onDateRangeChanged != null) {
                            widget.onDateRangeChanged!(_selectedDateRange!);
                          }
                          Navigator.of(context).pop();
                        }
                      : null,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.enabled ? onTap : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: widget.labelStyle ??
                theme.textTheme.bodySmall?.copyWith(
                  color: widget.enabled
                      ? AppColors.textSecondary
                      : AppColors.textDisabled,
                ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: widget.enabled ? Colors.white : AppColors.background,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: widget.enabled ? AppColors.border : AppColors.divider,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.showCalendarIcon) ...[
                  Icon(
                    Icons.calendar_today,
                    color: widget.enabled
                        ? (widget.activeColor ?? AppColors.primary)
                        : AppColors.textDisabled,
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
                ],
                Expanded(
                  child: Text(
                    value,
                    style: widget.valueStyle ??
                        theme.textTheme.bodyMedium?.copyWith(
                          color: widget.enabled
                              ? AppColors.textPrimary
                              : AppColors.textDisabled,
                        ),
                  ),
                ),
                if (widget.enabled)
                  Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.textSecondary,
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateRangeOption {
  final String label;
  final DateTimeRange range;

  DateRangeOption({
    required this.label,
    required this.range,
  });

  static List<DateRangeOption> getDefaultOptions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return [
      DateRangeOption(
        label: 'Hôm nay',
        range: DateTimeRange(
          start: today,
          end: today,
        ),
      ),
      DateRangeOption(
        label: 'Hôm qua',
        range: DateTimeRange(
          start: today.subtract(const Duration(days: 1)),
          end: today.subtract(const Duration(days: 1)),
        ),
      ),
      DateRangeOption(
        label: '7 ngày qua',
        range: DateTimeRange(
          start: today.subtract(const Duration(days: 6)),
          end: today,
        ),
      ),
      DateRangeOption(
        label: '30 ngày qua',
        range: DateTimeRange(
          start: today.subtract(const Duration(days: 29)),
          end: today,
        ),
      ),
      DateRangeOption(
        label: 'Tháng này',
        range: DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: today,
        ),
      ),
      DateRangeOption(
        label: 'Tháng trước',
        range: DateTimeRange(
          start: DateTime(now.month > 1 ? now.year : now.year - 1, 
                         now.month > 1 ? now.month - 1 : 12, 1),
          end: DateTime(now.year, now.month, 0),
        ),
      ),
    ];
  }
}

class DateRangePickerDialog extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final ValueChanged<DateTimeRange>? onDateRangeChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? title;
  final List<DateRangeOption>? quickOptions;
  final bool showQuickOptions;
  final bool allowSameDay;
  final DateFormat? dateFormat;

  const DateRangePickerDialog({
    Key? key,
    this.initialDateRange,
    this.onDateRangeChanged,
    this.firstDate,
    this.lastDate,
    this.title = 'Chọn khoảng thời gian',
    this.quickOptions,
    this.showQuickOptions = true,
    this.allowSameDay = true,
    this.dateFormat,
  }) : super(key: key);

  @override
  State<DateRangePickerDialog> createState() => _DateRangePickerDialogState();

  static Future<DateTimeRange?> show({
    required BuildContext context,
    DateTimeRange? initialDateRange,
    ValueChanged<DateTimeRange>? onDateRangeChanged,
    DateTime? firstDate,
    DateTime? lastDate,
    String? title,
    List<DateRangeOption>? quickOptions,
    bool showQuickOptions = true,
    bool allowSameDay = true,
    DateFormat? dateFormat,
  }) {
    return showDialog<DateTimeRange>(
      context: context,
      builder: (context) => DateRangePickerDialog(
        initialDateRange: initialDateRange,
        onDateRangeChanged: onDateRangeChanged,
        firstDate: firstDate,
        lastDate: lastDate,
        title: title,
        quickOptions: quickOptions,
        showQuickOptions: showQuickOptions,
        allowSameDay: allowSameDay,
        dateFormat: dateFormat,
      ),
    );
  }
}

class _DateRangePickerDialogState extends State<DateRangePickerDialog> {
  late DateTimeRange? _selectedDateRange;
  final List<DateRangeOption> _quickOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedDateRange = widget.initialDateRange;
    _quickOptions.addAll(widget.quickOptions ?? DateRangeOption.getDefaultOptions());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        width: 400.w,
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title!,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            if (widget.showQuickOptions) ...[
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: _quickOptions.map((option) {
                  final isSelected = _selectedDateRange != null &&
                      _selectedDateRange!.start == option.range.start &&
                      _selectedDateRange!.end == option.range.end;

                  return ChoiceChip(
                    label: Text(option.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDateRange = option.range;
                        });
                      }
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.h),
              Divider(height: 1.h, thickness: 1.h),
              SizedBox(height: 16.h),
            ],
            DateRangePicker(
              initialDateRange: _selectedDateRange,
              onDateRangeChanged: (dateRange) {
                setState(() {
                  _selectedDateRange = dateRange;
                });
              },
              firstDate: widget.firstDate,
              lastDate: widget.lastDate,
              showHeader: false,
              showActionButtons: false,
              allowSameDay: widget.allowSameDay,
              dateFormat: widget.dateFormat,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Hủy'),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: _selectedDateRange != null
                      ? () {
                          if (widget.onDateRangeChanged != null) {
                            widget.onDateRangeChanged!(_selectedDateRange!);
                          }
                          Navigator.of(context).pop(_selectedDateRange);
                        }
                      : null,
                  child: Text('Xác nhận'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
