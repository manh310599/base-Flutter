class Validators {
  static String? required(String? value, [String? message]) {
    if (value == null || value.isEmpty) {
      return message ?? 'Trường này không được để trống';
    }
    return null;
  }

  static String? email(String? value, [String? message]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return message ?? 'Email không hợp lệ';
    }
    
    return null;
  }

  static String? phone(String? value, [String? message]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    
    if (!phoneRegex.hasMatch(value)) {
      return message ?? 'Số điện thoại không hợp lệ';
    }
    
    return null;
  }

  static String? minLength(String? value, int minLength, [String? message]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    if (value.length < minLength) {
      return message ?? 'Tối thiểu $minLength ký tự';
    }
    
    return null;
  }

  static String? maxLength(String? value, int maxLength, [String? message]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    if (value.length > maxLength) {
      return message ?? 'Tối đa $maxLength ký tự';
    }
    
    return null;
  }

  static String? accountNumber(String? value, [String? message]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    final accountRegex = RegExp(r'^[0-9]{9,14}$');
    
    if (!accountRegex.hasMatch(value)) {
      return message ?? 'Số tài khoản không hợp lệ';
    }
    
    return null;
  }

  static String? money(String? value, [String? message]) {
    if (value == null || value.isEmpty) {
      return null;
    }
    
    // Remove currency symbols and separators
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleanValue.isEmpty || int.tryParse(cleanValue) == null) {
      return message ?? 'Số tiền không hợp lệ';
    }
    
    return null;
  }

  static String? combine(String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        return error;
      }
    }
    
    return null;
  }
}
