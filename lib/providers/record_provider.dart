import 'package:cash_flow_app/helpers/hive_db_helper.dart';
import 'package:cash_flow_app/models/cash_flow_summary.dart';
import 'package:cash_flow_app/models/month_report_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/date_time_util.dart';
import '../models/record.dart';

class RecordProvider with ChangeNotifier {
  List<Record> _records = [];

  Future<void> fetchAndSetRecords() async {
    _records = await HiveDBHelper().getRecords();
    notifyListeners();
  }

  RecordProvider() {
    fetchAndSetRecords();
  }

  void addRecord(Record record) {
    _records.add(record);
    HiveDBHelper().addRecord(record);
    notifyListeners();
  }

  Record? getRecordById(String id) {
    for (final record in _records) {
      if (record.id == id) {
        return record;
      }
    }
    return null;
  }

  void replaceRecord(Record newRecord) {
    Record? oldRecord = getRecordById(newRecord.id);
    if (oldRecord != null) {
      removeRecordById(oldRecord.id);
      addRecord(newRecord);
    }
  }

  List<Record> getRecordsByYearMonth(DateTime date) {
    List<Record> monthRecords = [];
    for (Record r in _records) {
      if (DateTimeUtil.sameYearMonth(
          date, DateTimeUtil.getDateTime(r.startDate))) {
        monthRecords.add(r);
      }

      /// Uncomment when we re-add the recurring records.
      // if (r.repeatDays != 0) {
      //   Duration recurrenceInDays = Duration(days: r.repeatDays);
      //   DateTime startDate = DateTimeUtil.getDateTime(r.startDate);
      //   DateTime endDate = DateTimeUtil.getRecentDate(
      //       DateTime(date.year, date.month + 1),
      //       DateTimeUtil.getDateTime(r.endDate));

      //   if (r.repeatDays == 30) {
      //     //handling the case of monthly recurrence.
      //     startDate =
      //         DateTime(startDate.year, startDate.month + 1, startDate.day);
      //   } else {
      //     startDate = startDate.add(recurrenceInDays);
      //   }

      //   int runningIndex = 0;
      //   while (startDate.isBefore(endDate)) {
      //     runningIndex += 1;
      //     if (DateTimeUtil.sameYearMonth(date, startDate)) {
      //       Record t = Record(
      //           id: "t$runningIndex${DateTime.now().millisecondsSinceEpoch}",
      //           repeatDays: r.repeatDays,
      //           name: r.name,
      //           endDate: r.endDate,
      //           startDate: startDate.toString().split(' ')[0],
      //           value: r.value,
      //           description: r.description);
      //       monthRecords.add(t);
      //     }
      //     startDate = startDate.add(recurrenceInDays);
      //   }
      // }
    }
    return monthRecords;
  }

  List<Record> getRecordsByTimeFrame(DateTime startDate, DateTime endDate) {
    List<Record> records = [];

    while (startDate.isBefore(endDate)) {
      List<Record> currMonthRecords = getRecordsByYearMonth(startDate);
      for (final r in currMonthRecords) {
        if (recordIsInTimeFrame(r, startDate, endDate)) {
          records.add(r);
        }
      }
      if (startDate.month == 12) {
        startDate = DateTime(startDate.year + 1);
      } else {
        startDate = DateTime(startDate.year, startDate.month + 1);
      }
    }
    return records;
  }

  bool recordIsInTimeFrame(Record r, DateTime start, DateTime end) {
    return start.isBefore(DateTimeUtil.getDateTime(r.startDate)) &&
        end.isAfter(DateTimeUtil.getDateTime(r.startDate));
  }

  bool recordTypeMatch(Record r, RecordType t) {
    return !(t == RecordType.expense && r.value > 0 ||
        t == RecordType.income && r.value < 0);
  }

  Future<List<Record>> getRecordsFromTimeFrameByKeyword(String keyword,
      DateTime startDate, DateTime endDate, RecordType type) async {
    List<Record> records = getRecordsByTimeFrame(startDate, endDate);
    if (keyword.isEmpty && type == RecordType.all) return records;

    List<Record> matchingRecords = [];
    for (Record r in records) {
      if ((r.name.contains(keyword) ||
              r.description.contains(keyword) ||
              keyword.isEmpty) &&
          recordTypeMatch(r, type)) {
        matchingRecords.add(r);
      }
    }

    return matchingRecords;
  }

  CashFlowSummary getCashFlowSummary(List<Record> records) {
    int income = 0;
    int expense = 0;
    for (Record r in records) {
      if (r.value > 0) {
        income += r.value;
      } else {
        expense += r.value;
      }
    }
    return CashFlowSummary(
        incomeSum: income, cashFlow: income + expense, expenseSum: expense);
  }

  CashFlowSummary? getMonthSummary(DateTime date) {
    List<Record> monthRecords = getRecordsByYearMonth(date);
    return monthRecords.isEmpty ? null : getCashFlowSummary(monthRecords);
  }

  /// Returns a list of month report cards, ordered from earliest month to oldest.
  /// The "from" date's month won't be included in the list!
  Future<List<MonthReportModel>> getMonthReportList(
      {required DateTime from, required int numberOfMonths}) {
    int fromMonth = from.month - 1;
    int fromYear = from.year;

    if (fromMonth < 1) {
      fromMonth = 12;
      fromYear -= 1;
    }

    List<MonthReportModel> list = [];
    return Future.value(list).then((_) {
      int currentMonth = 0;
      while (currentMonth < numberOfMonths) {
        int month = fromMonth - currentMonth;
        int year = fromYear;
        if (month < 1) {
          year -= 1;
          month += 12;
        }
        DateTime monthReportDate = DateTime(year, month);
        list.add(MonthReportModel(
            monthReportDate, getMonthSummary(monthReportDate)));

        currentMonth += 1;
      }
      return list;
    });
  }

  void removeRecordById(String id) {
    if (id.isEmpty) return;
    Record? record = getRecordById(id);
    if (record != null) {
      HiveDBHelper().removeRecord(record);
      _records.remove(record);
      notifyListeners();
    }
  }

  void clearRecords() {
    _records.clear();
    HiveDBHelper().clearRecords();
    notifyListeners();
  }
}
