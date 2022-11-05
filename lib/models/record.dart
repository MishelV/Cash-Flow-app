import 'package:hive/hive.dart';

part 'record.g.dart';

enum RecordType {
  all,
  expense,
  income,
}

@HiveType(typeId: 0)
class Record {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int value;

  @HiveField(4)
  final String startDate;

  @HiveField(5)
  final String endDate;

  @HiveField(6)
  final int repeatDays;

  Record({
    required this.id,
    required this.name,
    this.description = "",
    required this.value,
    required this.startDate,
    this.endDate = "",
    this.repeatDays = -1,
  });

  // Convert a Record into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'value': value,
      'startDate': startDate,
      'endDate': endDate,
      'repeatDays': repeatDays,
    };
  }
}
