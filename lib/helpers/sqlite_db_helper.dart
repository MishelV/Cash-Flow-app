import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/record.dart';

class SQFLiteDBHelper {
  Future<Database>? sqfliteDB;

  Future<Database> get database async {
    if (sqfliteDB != null) return sqfliteDB!;

    sqfliteDB = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'records.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          '''
CREATE TABLE records(id TEXT PRIMARY KEY, name TEXT, description TEXT, value INTEGER, startDate TEXT, endDate TEXT, repeatDays INTEGER)
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );

    return sqfliteDB!;
  }

  Future<List<Record>> getRecords() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('records');

    // Convert the List<Map<String, dynamic> into a List<Record>.
    return List.generate(maps.length, (i) {
      return Record(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
        value: maps[i]['value'],
        startDate: maps[i]['startDate'],
        endDate: maps[i]['endDate'],
        repeatDays: maps[i]['repeatDays'],
      );
    });
  }

  // Define a function that inserts a record into the database
  Future<void> insertRecord(Record record) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Record into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same record is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRecord(Record record) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given record.
    await db.update(
      'records',
      record.toMap(),
      // Ensure that the record has a matching id.
      where: 'id = ?',
      // Pass the record's id as a whereArg to prevent SQL injection.
      whereArgs: [record.id],
    );
  }

  Future<void> deleteRecord(String id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the record from the database.
    await db.delete(
      'records',
      // Use a `where` clause to delete a specific record.
      where: 'id = ?',
      // Pass the record's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
