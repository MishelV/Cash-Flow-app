import 'cash_flow_summary.dart';

class MonthReportModel {
  DateTime date;
  CashFlowSummary? summary;
  MonthReportModel(this.date, this.summary);
}
