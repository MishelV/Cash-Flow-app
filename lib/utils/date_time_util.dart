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

  static DateTime getDateTime(String s) {
    List<String> dateTimeList = s.split(' ');
    if (dateTimeList.length == 1) return getDate(s);

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

  static DateTime getDate(String date) {
    if (date.contains(" ")) {
      return getDateTime(date);
    }
    final year = int.parse(date.split('-')[0]);
    final month = int.parse(date.split('-')[1]);
    final day = int.parse(date.split('-')[2]);

    // Adding 1 hour to avoid the cases for same day comparison.
    const hour = 1;
    return DateTime(year, month, day, hour);
  }

  static String getDateString(String s) {
    DateTime date = getDateTime(s);
    return DateFormat("dd.MM.yyyy HH:mm").format(date);
  }

  static bool sameYearMonth(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month;
  }

  static DateTime getRecentDate(DateTime d1, DateTime d2) {
    if (d1.isAfter(d2)) return d2;
    return d1;
  }
}
