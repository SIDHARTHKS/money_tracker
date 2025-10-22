// lib/helper/formatters.dart
import 'package:intl/intl.dart';

/// Converts "8374999.00" -> "83,74,999.00" (Indian grouping), keeps 2 decimals.
String formatIndianCurrency(String amount) {
  // remove anything that's not a digit, minus or dot
  final sanitized = amount.toString().replaceAll(RegExp(r'[^\d\.-]'), '');
  final value = double.tryParse(sanitized) ?? 0.0;

  final nf = NumberFormat.currency(
    locale: 'en_IN', // Indian numbering (lakhs/crores)
    symbol: '', // no ₹ symbol
    decimalDigits: 2,
  );

  return nf.format(value).trim();
}

/// Overload if you already have a number
String formatIndianCurrencyNum(num amount) {
  final nf = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '',
    decimalDigits: 2,
  );
  return nf.format(amount).trim();
}

/// Reverse: "83,74,999.00" -> 8374999.00
double parseIndianCurrency(String formatted) {
  return double.tryParse(formatted.replaceAll(',', '')) ?? 0.0;
}
