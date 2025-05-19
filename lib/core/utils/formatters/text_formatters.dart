import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
    
    // Calculate cursor position
    final oldTextLength = oldValue.text.length;
    final newTextLength = formattedText.length;
    final oldSelectionStart = oldValue.selection.start;
    
    // Adjust cursor position based on added spaces
    int selectionOffset = newValue.selection.start;
    if (selectionOffset > 0) {
      // Count spaces before cursor in new text
      int spacesInNew = ' '.allMatches(formattedText.substring(0, selectionOffset)).length;
      // Count spaces before cursor in old text
      int spacesInOld = oldSelectionStart > 0
          ? ' '.allMatches(oldValue.text.substring(0, oldSelectionStart)).length
          : 0;
      
      // Adjust for added spaces
      selectionOffset += (spacesInNew - spacesInOld);
      
      // Ensure cursor position is valid
      if (selectionOffset > formattedText.length) {
        selectionOffset = formattedText.length;
      } else if (selectionOffset < 0) {
        selectionOffset = 0;
      }
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: selectionOffset),
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

/// A formatter for phone numbers.
/// 
/// This formatter formats phone numbers as "(XXX) XXX-XXXX" for US numbers
/// or in a custom format for other countries.
class PhoneNumberFormatter extends TextInputFormatter {
  final String countryCode;
  
  PhoneNumberFormatter({this.countryCode = 'US'});
  
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    if (text.isEmpty) {
      return newValue;
    }
    
    // Remove all non-digit characters
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    String formattedText;
    
    // Format based on country code
    switch (countryCode) {
      case 'US':
        formattedText = _formatUSPhoneNumber(digitsOnly);
        break;
      case 'VN':
        formattedText = _formatVNPhoneNumber(digitsOnly);
        break;
      default:
        formattedText = digitsOnly;
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
  
  /// Formats a US phone number as "(XXX) XXX-XXXX".
  String _formatUSPhoneNumber(String digits) {
    if (digits.length < 4) {
      return digits;
    } else if (digits.length < 7) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3)}';
    } else {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6, digits.length.clamp(0, 10))}';
    }
  }
  
  /// Formats a Vietnamese phone number.
  String _formatVNPhoneNumber(String digits) {
    if (digits.length < 4) {
      return digits;
    } else if (digits.length < 7) {
      return '${digits.substring(0, 3)} ${digits.substring(3)}';
    } else {
      return '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, digits.length.clamp(0, 10))}';
    }
  }
}

/// A formatter for currency values.
/// 
/// This formatter formats numbers as currency with the specified locale and symbol.
class CurrencyFormatter extends TextInputFormatter {
  final NumberFormat _formatter;
  final String locale;
  final String symbol;
  final int decimalDigits;
  
  CurrencyFormatter({
    this.locale = 'en_US',
    this.symbol = '\$',
    this.decimalDigits = 2,
  }) : _formatter = NumberFormat.currency(
         locale: locale,
         symbol: '',
         decimalDigits: decimalDigits,
       );
  
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Remove all non-digit characters except decimal point
    final cleanText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');
    
    // Parse the clean text as a number
    final number = double.tryParse(cleanText);
    if (number == null) {
      return oldValue;
    }
    
    // Format the number as currency
    final formattedText = _formatter.format(number);
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

/// A formatter that limits input to a specific set of characters.
class CharacterSetFormatter extends TextInputFormatter {
  final String allowedCharacters;
  
  CharacterSetFormatter({required this.allowedCharacters});
  
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regExp = RegExp('[^$allowedCharacters]');
    final cleanText = newValue.text.replaceAll(regExp, '');
    
    if (cleanText == newValue.text) {
      return newValue;
    }
    
    return TextEditingValue(
      text: cleanText,
      selection: TextSelection.collapsed(offset: cleanText.length),
    );
  }
}

/// A formatter that masks input with a custom character.
/// 
/// This is useful for sensitive information like credit card numbers
/// where you want to show only the last few digits.
class MaskTextFormatter extends TextInputFormatter {
  final String mask;
  final int visibleDigits;
  
  MaskTextFormatter({
    this.mask = '•',
    this.visibleDigits = 4,
  });
  
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    
    if (text.isEmpty || text.length <= visibleDigits) {
      return newValue;
    }
    
    final maskedPart = mask * (text.length - visibleDigits);
    final visiblePart = text.substring(text.length - visibleDigits);
    final maskedText = maskedPart + visiblePart;
    
    return TextEditingValue(
      text: maskedText,
      selection: TextSelection.collapsed(offset: maskedText.length),
    );
  }
  
  /// Masks a string with the specified mask character, showing only the last few digits.
  static String maskString(String text, {String mask = '•', int visibleDigits = 4}) {
    if (text.isEmpty || text.length <= visibleDigits) {
      return text;
    }
    
    final maskedPart = mask * (text.length - visibleDigits);
    final visiblePart = text.substring(text.length - visibleDigits);
    
    return maskedPart + visiblePart;
  }
}
