import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

/// A search text field with debounce functionality.
/// 
/// This widget provides a search input with:
/// - Debounce to prevent excessive API calls
/// - Clear button to reset search
/// - Search icon prefix
/// - Customizable appearance
class SearchTextField extends StatefulWidget {
  /// The controller for the text field.
  final TextEditingController? controller;
  
  /// Callback that is called when the search text changes after the debounce period.
  final ValueChanged<String>? onChanged;
  
  /// Callback that is called when the clear button is pressed.
  final VoidCallback? onClear;
  
  /// The hint text to display when the field is empty.
  final String hint;
  
  /// The debounce duration to wait before calling onChanged.
  final Duration debounceDuration;
  
  /// Whether to show the clear button when the field has text.
  final bool showClearButton;
  
  /// Whether to show the search icon.
  final bool showSearchIcon;
  
  /// The border radius of the text field.
  final double borderRadius;
  
  /// The background color of the text field.
  final Color? backgroundColor;
  
  /// The text style of the input.
  final TextStyle? style;
  
  /// The text style of the hint.
  final TextStyle? hintStyle;
  
  /// The focus node for the text field.
  final FocusNode? focusNode;
  
  /// Whether the text field should be autofocused.
  final bool autofocus;
  
  /// The text input action.
  final TextInputAction textInputAction;
  
  /// Callback that is called when the search is submitted.
  final ValueChanged<String>? onSubmitted;

  const SearchTextField({
    Key? key,
    this.controller,
    this.onChanged,
    this.onClear,
    this.hint = 'Tìm kiếm...',
    this.debounceDuration = const Duration(milliseconds: 500),
    this.showClearButton = true,
    this.showSearchIcon = true,
    this.borderRadius = 8.0,
    this.backgroundColor,
    this.style,
    this.hintStyle,
    this.focusNode,
    this.autofocus = false,
    this.textInputAction = TextInputAction.search,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;
  Timer? _debounceTimer;
  bool _hasText = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _hasText = _controller.text.isNotEmpty;
    
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    
    if (widget.onChanged != null) {
      if (_debounceTimer?.isActive ?? false) {
        _debounceTimer!.cancel();
      }
      
      _debounceTimer = Timer(widget.debounceDuration, () {
        widget.onChanged!(_controller.text);
      });
    }
  }

  void _clearSearch() {
    _controller.clear();
    if (widget.onClear != null) {
      widget.onClear!();
    } else if (widget.onChanged != null) {
      widget.onChanged!('');
    }
    
    // Request focus after clearing
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      style: widget.style ?? theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: widget.hintStyle ?? 
            theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textHint,
            ),
        prefixIcon: widget.showSearchIcon 
            ? const Icon(Icons.search, color: AppColors.textSecondary)
            : null,
        suffixIcon: _hasText && widget.showClearButton
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                onPressed: _clearSearch,
              )
            : null,
        filled: true,
        fillColor: widget.backgroundColor ?? AppColors.background,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius.r),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
