enum RecordType {
  all,
  expense,
  income,
}

class Record {
  final String id;

  final String name;

  final String description;

  final int value;

  final String startDate;

  final String endDate;

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
