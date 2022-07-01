import 'package:cash_flow_app/models/record.dart';
import 'package:hive/hive.dart';

class DBHelper {
  void initHive() {}

  // Records

  get recordBox async {
    return await Hive.openBox('records');
  }

  Future<List<Record>> getRecords() async {
    List<Record> records = [];
    Box hive = await recordBox;
    List<String>? listOfIds = hive.get('recordIds');
    if (listOfIds == null) return [];
    for (final id in listOfIds) {
      final record = hive.get(id);
      if (record != null) records.add(record);
    }
    return records;
  }

  void addRecord(Record record) async {
    Box hive = await recordBox;
    List<String>? listOfIds = hive.get('recordIds');
    listOfIds ??= [];
    listOfIds.add(record.id);
    hive.put('recordIds', listOfIds);
    hive.put(record.id, record);
  }

  void removeRecord(Record record) async {
    Box hive = await recordBox;
    List<String>? listOfIds = hive.get('recordIds');
    listOfIds ??= [];
    listOfIds.remove(record.id);
    hive.put('recordIds', listOfIds);
    hive.delete(record.id);
  }

  void clearRecords() async {
    Box hive = await recordBox;
    hive.clear();
  }
}
