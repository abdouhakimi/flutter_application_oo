import 'package:intl/intl.dart';

class DateUtils {
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final DateFormat _displayDateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _displayTimeFormat = DateFormat('hh:mm a');

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatTime(DateTime time) {
    return _timeFormat.format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  static String formatDisplayDate(DateTime date) {
    return _displayDateFormat.format(date);
  }

  static String formatDisplayTime(DateTime time) {
    return _displayTimeFormat.format(time);
  }

  static DateTime parseDate(String dateString) {
    return _dateFormat.parse(dateString);
  }

  static DateTime parseTime(String timeString) {
    return _timeFormat.parse(timeString);
  }

  static DateTime parseDateTime(String dateTimeString) {
    return _dateTimeFormat.parse(dateTimeString);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static String getRelativeDate(DateTime date) {
    if (isToday(date)) {
      return 'اليوم';
    } else if (isYesterday(date)) {
      return 'أمس';
    } else if (isThisWeek(date)) {
      return 'هذا الأسبوع';
    } else if (isThisMonth(date)) {
      return 'هذا الشهر';
    } else {
      return formatDisplayDate(date);
    }
  }

  static List<DateTime> getDaysInRange(DateTime start, DateTime end) {
    List<DateTime> days = [];
    for (DateTime date = start;
        date.isBefore(end.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      days.add(date);
    }
    return days;
  }

  static int getDaysDifference(DateTime date1, DateTime date2) {
    return date1.difference(date2).inDays;
  }

  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}
