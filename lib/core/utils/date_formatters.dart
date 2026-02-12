// lib/core/utils/date_formatters.dart
// Centralized date/time formatting utilities.

import 'package:flutter/material.dart';

/// Centralized date and time formatting for consistent display across screens.
class DateFormatters {
  DateFormatters._();

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Short date with abbreviated month: "Jan 15, 2026"
  static String shortDate(DateTime date) =>
      '${_months[date.month - 1]} ${date.day}, ${date.year}';

  /// 12-hour time from TimeOfDay: "2:30 PM"
  static String time12h(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// 12-hour time from DateTime: "2:30 PM"
  static String dateTime12h(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Short date with time: "Jan 15, 2026 2:30 PM"
  static String shortDateTime(DateTime dt) =>
      '${shortDate(dt)} ${dateTime12h(dt)}';

  /// Numeric date: "1/15/2026"
  static String numericDate(DateTime date) =>
      '${date.month}/${date.day}/${date.year}';
}
