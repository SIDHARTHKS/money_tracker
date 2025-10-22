import 'package:intl/intl.dart';

import 'app_string.dart';

class DateHelper {
  static String misDateFormat = 'dd/MM/yyyy';
  static String dateFormat = 'dd-MM-yyyy';
  static String misDateTimeFormat = 'dd MMM hh:mm a';
  static String misServiceDateTimeFormat = 'dd/MM/yyyy HH:mm:ss';

  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday) return "Today";

    // Format as 'Oct 25'
    return "${_monthAbbreviation(date.month)} ${date.day}";
  }

  String formatDateToWeekdayMonthDay(DateTime date) {
    // Format: "TUE OCT 25"
    return DateFormat('EEE MMM dd').format(date).toUpperCase();
  }

// Helper function to get month abbreviation
  String _monthAbbreviation(int month) {
    const months = [
      '', // placeholder for 0 index
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  String formatMonthYear(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }

  static String convertDateTimeToString({
    required DateTime dateTime,
    String? outputFormat,
  }) {
    try {
      outputFormat ??= misDateFormat;
      DateFormat outputFormatter = DateFormat(outputFormat);
      return outputFormatter.format(dateTime);
    } catch (e) {
      throw Exception('$dateFormattingErrorMsg: $e');
    }
  }

  static String convertDateString({
    required String dateString,
    String? inputFormat,
    String? outputFormat,
  }) {
    try {
      inputFormat ??= misDateFormat;
      outputFormat ??= misDateFormat;
      DateFormat inputFormatter = DateFormat(inputFormat);
      DateFormat outputFormatter = DateFormat(outputFormat);
      DateTime dateTime = inputFormatter.parse(dateString);
      return outputFormatter.format(dateTime);
    } catch (e) {
      throw Exception('$dateParsingErrorMsg: $e');
    }
  }

  static DateTime convertStringToDateTime({
    required String dateString,
    String? inputFormat,
  }) {
    try {
      inputFormat ??= misDateFormat;
      DateFormat inputFormatter = DateFormat(inputFormat);
      DateTime dateTime = inputFormatter.parse(dateString);
      return dateTime;
    } catch (e) {
      throw Exception('$dateParsingErrorMsg: $e');
    }
  }

  static DateTime convertStringToDateTimeWithSpecificFormat({
    required String dateString,
    required String inputFormat,
    required String outputFormat,
  }) {
    try {
      // Parsing the date string to DateTime using the input format
      DateFormat inputFormatter = DateFormat(inputFormat);
      DateTime dateTime = inputFormatter.parse(dateString);

      // Ensuring the DateTime corresponds to the output format
      DateFormat outputFormatter = DateFormat(outputFormat);
      String formattedDate = outputFormatter.format(dateTime);
      DateTime finalDateTime = outputFormatter.parse(formattedDate);

      return finalDateTime;
    } catch (e) {
      throw Exception('$dateParsingErrorMsg: $e');
    }
  }

  static String formatDateWithSuperscript(DateTime date) {
    String day = date.day.toString();
    String suffix = getDaySuffix(date.day);
    String month = getMonthAbbreviation(date.month);

    return "$day$suffix $month";
  }

  static String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return "th";
    }
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  static String getMonthAbbreviation(int month) {
    List<String> months = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC"
    ];
    return months[month - 1];
  }
}
