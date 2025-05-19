import 'package:intl/intl.dart';

/// Utility class for formatting money values.
class MoneyFormatter {
  /// Default currency symbol.
  static const String defaultCurrencySymbol = '\$';

  /// Default locale.
  static const String defaultLocale = 'en_US';

  /// Formats a number as currency with the given currency symbol and locale.
  static String formatCurrency(
    num amount, {
    String currencySymbol = defaultCurrencySymbol,
    String locale = defaultLocale,
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Formats a number as currency with the given currency code and locale.
  static String formatCurrencyWithCode(
    num amount, {
    String currencyCode = 'USD',
    String locale = defaultLocale,
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.simpleCurrency(
      locale: locale,
      name: currencyCode,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Formats a number as compact currency (e.g., "$1.2K").
  static String formatCompactCurrency(
    num amount, {
    String currencySymbol = defaultCurrencySymbol,
    String locale = defaultLocale,
  }) {
    final formatter = NumberFormat.compactCurrency(
      locale: locale,
      symbol: currencySymbol,
    );
    return formatter.format(amount);
  }

  /// Formats a number with commas (e.g., "1,234.56").
  static String formatWithCommas(
    num amount, {
    String locale = defaultLocale,
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    return formatter.format(amount);
  }

  /// Formats a number as a percentage (e.g., "12.34%").
  static String formatPercentage(
    num percentage, {
    String locale = defaultLocale,
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.percentPattern(locale)
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    return formatter.format(percentage / 100);
  }

  /// Formats a number as a compact number (e.g., "1.2K").
  static String formatCompact(
    num amount, {
    String locale = defaultLocale,
  }) {
    final formatter = NumberFormat.compact(locale: locale);
    return formatter.format(amount);
  }

  /// Formats a number with the given decimal digits.
  static String formatDecimal(
    num amount, {
    String locale = defaultLocale,
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = decimalDigits
      ..maximumFractionDigits = decimalDigits;
    return formatter.format(amount);
  }

  /// Formats a number as an integer (e.g., "1,234").
  static String formatInteger(
    num amount, {
    String locale = defaultLocale,
  }) {
    final formatter = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = 0
      ..maximumFractionDigits = 0;
    return formatter.format(amount);
  }

  /// Parses a currency string to a number.
  static num? parseCurrency(
    String currencyString, {
    String locale = defaultLocale,
    String? currencySymbol,
  }) {
    try {
      final formatter = NumberFormat.currency(
        locale: locale,
        symbol: currencySymbol,
      );
      return formatter.parse(currencyString);
    } catch (e) {
      return null;
    }
  }

  /// Formats a number with a plus or minus sign (e.g., "+$1,234.56" or "-$1,234.56").
  static String formatWithSign(
    num amount, {
    String currencySymbol = defaultCurrencySymbol,
    String locale = defaultLocale,
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol,
      decimalDigits: decimalDigits,
    );
    final formattedAmount = formatter.format(amount.abs());
    return amount >= 0 ? '+$formattedAmount' : '-$formattedAmount';
  }

  /// Formats a number for a transaction (positive for deposits, negative for withdrawals).
  static String formatTransaction(
    num amount, {
    String currencySymbol = defaultCurrencySymbol,
    String locale = defaultLocale,
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: currencySymbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }
}
