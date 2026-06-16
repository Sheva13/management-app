import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _fullDateFormat = DateFormat('dd MMMM yyyy', 'id_ID');
  static final DateFormat _shortDateFormat = DateFormat('dd MMM yyyy', 'id_ID');
  static final DateFormat _dayFormat = DateFormat('EEEE', 'id_ID');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'id_ID');
  static final DateFormat _timeFormat = DateFormat('HH:mm', 'id_ID');
  static final DateFormat _fullDateTimeFormat =
      DateFormat('dd MMMM yyyy, HH:mm', 'id_ID');
  static final DateFormat _logFormat = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

  static String formatFull(DateTime date) {
    return _fullDateFormat.format(date);
  }

  static String formatShort(DateTime date) {
    return _shortDateFormat.format(date);
  }

  static String formatDay(DateTime date) {
    return _dayFormat.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  static String formatFullDateTime(DateTime date) {
    return _fullDateTimeFormat.format(date);
  }

  static String formatLog(DateTime date) {
    return _logFormat.format(date);
  }

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini, ${formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Kemarin, ${formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return formatShort(date);
    }
  }

  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }

  static DateTime startOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime endOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0, 23, 59, 59);
  }
}
