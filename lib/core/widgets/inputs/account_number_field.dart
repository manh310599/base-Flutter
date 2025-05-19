import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_text_field.dart';
import '../../theme/app_colors.dart';
import '../../utils/formatters/text_formatters.dart';

/// A text field for entering account numbers.
/// 
/// This field automatically formats the input as an account number
/// with spaces after every 4 digits (e.g., "1234 5678 9012 3456").
class AccountNumberField extends StatefulWidget {
  /// The label text for the field.
  final String? label;
  
  /// The hint text for the field.
  final String? hint;
  
  /// The controller for the field.
  final TextEditingController? controller;
  
  /// The validator function for the field.
  final String? Function(String?)? validator;
  
  /// The callback to execute when the field value changes.
  final ValueChanged<String>? onChanged;
  
  /// Whether the field is read-only.
  final bool readOnly;
  
  /// The callback to execute when the field is tapped.
  final VoidCallback? onTap;
  
  /// The focus node for the field.
  final FocusNode? focusNode;
  
  /// Whether the field should automatically get focus.
  final bool autofocus;
  
  /// The initial value for the field.
  final String? initialValue;
  
  /// Whether the field is enabled.
  final bool enabled;
  
  /// The bank icon to display in the field.
  final Widget? bankIcon;
  
  /// The maximum length of the account number.
  final int maxLength;
  
  /// Whether to show a copy button.
  final bool showCopyButton;
  
  /// The callback to execute when the copy button is pressed.
  final VoidCallback? onCopy;

  const AccountNumberField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.autofocus = false,
    this.initialValue,
    this.enabled = true,
    this.bankIcon,
    this.maxLength = 19, // Standard credit card length with spaces
    this.showCopyButton = false,
    this.onCopy,
  }) : super(key: key);

  @override
  State<AccountNumberField> createState() => _AccountNumberFieldState();
}

class _AccountNumberFieldState extends State<AccountNumberField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    
    if (widget.initialValue != null) {
      _controller.text = AccountNumberFormatter.format(widget.initialValue!);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      hint: widget.hint ?? 'Enter account number',
      controller: _controller,
      validator: widget.validator,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        if (widget.onChanged != null) {
          // Pass the raw value without formatting
          widget.onChanged!(value.replaceAll(' ', ''));
        }
      },
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        AccountNumberFormatter(),
      ],
      prefixIcon: widget.bankIcon != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: widget.bankIcon,
            )
          : null,
      suffixIcon: widget.showCopyButton
          ? IconButton(
              icon: Icon(
                Icons.copy,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
              onPressed: () {
                final accountNumber = _controller.text.replaceAll(' ', '');
                Clipboard.setData(ClipboardData(text: accountNumber));
                
                // Show a snackbar or toast
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account number copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
                
                if (widget.onCopy != null) {
                  widget.onCopy!();
                }
              },
            )
          : null,
    );
  }
}

/// A formatter for account numbers.
/// 
/// This formatter adds a space after every 4 digits.
class AccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    if (text.isEmpty) {
      return newValue;
    }
    
    // Remove all spaces
    final digitsOnly = text.replaceAll(' ', '');
    final formattedText = format(digitsOnly);
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
        offset: formattedText.length,
      ),
    );
  }
  
  /// Formats an account number by adding spaces after every 4 digits.
  static String format(String text) {
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }
    
    return buffer.toString();
  }
}
