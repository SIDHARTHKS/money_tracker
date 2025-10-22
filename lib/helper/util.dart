import 'package:flutter/material.dart';

import 'app_message.dart';

class Util {
  static bool isStringNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  static bool isNavigationBarVisible(BuildContext context) {
    double gap = MediaQuery.of(context).padding.bottom;
    appLog('isNavigationBarVisible gap: $gap');
    return gap > 28;
  }

  static Map<String, List<String>> getFinancialYears(DateTime joiningDate) {
    List<String> allMonths = [
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
      'Jan',
      'Feb',
      'Mar',
    ];

    Map<String, List<String>> financialYears = {};
    int startYear = joiningDate.year;
    int startMonth = joiningDate.month;
    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;
    int currentMonth = currentDate.month;
    // currentMonth = 1; // For testing

    // First financial year (starting from joining month)
    int firstYearEnd = (startMonth < 4) ? startYear : startYear + 1;
    String firstYearKey = "$startYear-$firstYearEnd";
    financialYears[firstYearKey] = allMonths.sublist(
      startMonth < 4 ? 0 : startMonth - 4,
    );

    // Loop for financial years till current date
    int year = firstYearEnd;
    while (year < currentYear || (year == currentYear && currentMonth > 4)) {
      int nextYear = year + 1;
      String key = "$year-$nextYear";

      if (nextYear == currentYear || nextYear == currentYear + 1) {
        // Exclude March if current month is before April
        financialYears[key] = allMonths.sublist(
          0,
          currentMonth < 4
              ? allMonths.length - (4 - currentMonth)
              : allMonths.length,
        );
        // currentMonth < 4
        //     ? allMonths.length - (4 - currentMonth)
        //     : allMonths.length);
      } else {
        // Full financial year
        financialYears[key] = List.from(allMonths);
      }

      year = nextYear;
    }
    print(financialYears);
    return financialYears;
  }
}
