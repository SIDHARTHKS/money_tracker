import 'package:flutter/services.dart';

class AmountFormatter extends TextInputFormatter {
  final int maxDigitsBeforeDecimal;
  final int maxDigitsAfterDecimal;

  AmountFormatter({
    this.maxDigitsBeforeDecimal = 8,
    this.maxDigitsAfterDecimal = 2,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Allow empty
    if (text.isEmpty) return newValue;

    // Split at decimal
    final parts = text.split('.');

    final beforeDecimal = parts[0];
    final afterDecimal = parts.length > 1 ? parts[1] : '';

    // Reject if before-decimal part exceeds limit
    if (beforeDecimal.length > maxDigitsBeforeDecimal) {
      return oldValue;
    }

    // Reject if after-decimal part exceeds limit
    if (afterDecimal.length > maxDigitsAfterDecimal) {
      return oldValue;
    }

    // Reject multiple decimals
    if ('.'.allMatches(text).length > 1) {
      return oldValue;
    }

    // Otherwise accept new value
    return newValue;
  }
}
