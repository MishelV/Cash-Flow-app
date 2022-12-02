import 'package:intl/intl.dart';

class DateTimeUtil {
  static const dateFormat = 'yyyy-mm-dd hh:mm';

  static const months = [
    'Null',
    'January',
    'Fabruary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static DateTime getDateWithTimeFromString(String s) {
    List<String> dateTimeList = s.split(' ');
    if (dateTimeList.length == 1) return getDateFromString(s);

    final String date = dateTimeList[0];
    final String time = dateTimeList[1];

    final year = int.parse(date.split('-')[0]);
    final month = int.parse(date.split('-')[1]);
    final day = int.parse(date.split('-')[2]);
    final hour = int.parse(time.split(':')[0]);
    final minute = int.parse(time.split(':')[1]);

    // Adding +1 to avoid the cases for same day comparison.
    return DateTime(year, month, day, hour, minute + 1);
  }

  static DateTime getDateFromString(String date) {
    if (date.contains(" ")) {
      return getDateWithTimeFromString(date);
    }
    final year = int.parse(date.split('-')[0]);
    final month = int.parse(date.split('-')[1]);
    final day = int.parse(date.split('-')[2]);

    // Adding 1 hour to avoid the cases for same day comparison.
    const hour = 1;
    return DateTime(year, month, day, hour);
  }

  static String getFormattedDateStringFromString(String s) {
    DateTime date = getDateWithTimeFromString(s);
    return DateFormat("dd.MM.yyyy HH:mm").format(date);
  }

  static bool isSameYearMonth(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month;
  }

  static DateTime getEarlierDate(DateTime d1, DateTime d2) {
    if (d1.isAfter(d2)) return d2;
    return d1;
  }

  static DateTime endOfMonthFor(DateTime date) {
    DateTime nextMonth = date.month == 12
        ? DateTime(date.year + 1, 1)
        : DateTime(date.year, date.month + 1);

    return nextMonth.subtract(const Duration(days: 1));
  }

  static DateTime nextYearOf(DateTime date) {
    return date.add(const Duration(days: 365));
  }

  static DateTime previousYearOf(DateTime date) {
    return date.subtract(const Duration(days: 365));
  }
}
