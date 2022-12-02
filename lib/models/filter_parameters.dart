import 'record.dart';

class FilterParameters {
  String keyword;
  DateTime startDate;
  DateTime endDate;
  RecordType type;

  FilterParameters(
      {required this.keyword,
      required this.startDate,
      required this.endDate,
      required this.type});
}
