import 'package:cash_flow_app/helpers/db_helper.dart';
import 'package:cash_flow_app/models/cash_flow_summary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/date_time_util.dart';
import '../models/record.dart';

class RecordProvider with ChangeNotifier {
  List<Record> _records = [];

  Future<void> fetchAndSetRecords() async {
    _records = await DBHelper().getRecords();
    notifyListeners();
  }

  RecordProvider() {
    fetchAndSetRecords();
  }

  // get records {
  //   var copiedRecords = [..._records];
  //   copiedRecords.sort((r1, r2) => r1.id.compareTo(r1.id));
  //   return copiedRecords;
  // }

  void addRecord(Record record) {
    _records.add(record);
    DBHelper().addRecord(record);
    notifyListeners();
  }

  Record getRecordById(String id) {
    return _records.firstWhere((element) => (element.id == id));
  }

  List<Record> getRecordsByYearMonth(DateTime date) {
    List<Record> monthRecords = [];
    for (Record r in _records) {
      if (DateTimeUtil.sameYearMonth(
          date, DateTimeUtil.getDateTime(r.startDate))) {
        monthRecords.add(r);
      }
      if (r.repeatDays != 0) {
        Duration recurrenceInDays = Duration(days: r.repeatDays);
        DateTime startDate = DateTimeUtil.getDateTime(r.startDate);
        DateTime endDate = DateTimeUtil.getRecentDate(
            DateTime(date.year, date.month + 1),
            DateTimeUtil.getDateTime(r.endDate));
        startDate = startDate.add(recurrenceInDays);
        while (startDate.isBefore(endDate)) {
          if (DateTimeUtil.sameYearMonth(date, startDate)) {
            Record t = Record(
                id: "t_${DateTime.now().millisecondsSinceEpoch}",
                repeatDays: r.repeatDays,
                name: r.name,
                endDate: r.endDate,
                startDate: startDate.toString().split(' ')[0],
                value: r.value,
                description: r.description);
            monthRecords.add(t);
          }
          startDate = startDate.add(recurrenceInDays);
        }
      }
    }
    return monthRecords;
  }

  List<Record> getRecordsByTimeFrame(DateTime startDate, DateTime endDate) {
    List<Record> records = [];

    while (startDate.isBefore(endDate)) {
      List<Record> currMonthRecords = getRecordsByYearMonth(startDate);
      records.addAll(currMonthRecords);
      if (startDate.month == 12) {
        startDate = DateTime(startDate.year + 1);
      } else {
        startDate = DateTime(startDate.year, startDate.month + 1);
      }
    }
    return records;
  }

  bool recordTypeMatch(Record r, RecordType t) {
    return !(t == RecordType.expense && r.value > 0 ||
        t == RecordType.income && r.value < 0);
  }

  List<Record> getRecordsFromTimeFrameByKeyword(
      String keyword, DateTime startDate, DateTime endDate, RecordType type) {
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

  CashFlowSummary getMonthSummary(DateTime date) {
    List<Record> monthRecords = getRecordsByYearMonth(date);
    return getCashFlowSummary(monthRecords);
  }

  void removeRecordById(String id) {
    if (id.isEmpty) return;
    Record record = getRecordById(id);
    DBHelper().removeRecord(record);
    _records.remove(record);
    notifyListeners();
  }

  void clearRecords() {
    _records.clear();
    DBHelper().clearRecords();
    notifyListeners();
  }
}
