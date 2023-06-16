import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/import_records_models.dart';
import '../models/record.dart';

class SQFLiteDBHelper {
  static const databaseName = 'records.db';
  static const tableName = 'records';

  Future<Database>? sqfliteDB;

  Future<Database> get database async {
    if (sqfliteDB != null) return sqfliteDB!;

    sqfliteDB = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), databaseName),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          '''
CREATE TABLE $tableName(id TEXT PRIMARY KEY, name TEXT, description TEXT, value INTEGER, startDate TEXT, endDate TEXT, repeatDays INTEGER)
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
    final List<Map<String, dynamic>> maps = await db.query(tableName);

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
      tableName,
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateRecord(Record record) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given record.
    await db.update(
      tableName,
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
      tableName,
      // Use a `where` clause to delete a specific record.
      where: 'id = ?',
      // Pass the record's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  static Future<String> filePath() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      if (kDebugMode) {
        print('External storage not available');
      }
      return '';
    }

    return '${directory.path}/table_data.csv';
  }

// This function exports the records table to a CSV file and returns a boolean
// value indicating success or failure.
// It uses asynchronous programming to avoid blocking the UI thread.
  Future<String> exportTableToCSV() async {
    final database = await openDatabase(databaseName);
    final tableData = await database.query(tableName);

    final csvData = [[]];

    // Add header row
    csvData.add(tableData.first.keys.toList());

    // Add data rows
    for (final row in tableData) {
      csvData.add(row.values.toList());
    }

    // For some reason the first element might be empty so it should be removed
    // so that the table is able to convert to a string successfully below.
    if (csvData[0].isEmpty) {
      csvData.removeAt(0);
    }

    final csvString = const ListToCsvConverter().convert(csvData);

    final filePath = await SQFLiteDBHelper.filePath();
    final file = File(filePath);
    await file.writeAsString(csvString);

    return file.path;
  }

  // Function to import "records" table data from a CSV file.
  // It uses asynchronous programming to avoid blocking the UI thread.
  Future<ImportStatus> importTableFromCSV(ImportOption option,
      {String? fileDownloadPath}) async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      if (kDebugMode) {
        print('External storage not available');
      }
      return ImportStatus.fileNotFound;
    }

    // Set file path
    final filePath = fileDownloadPath ?? '${directory.path}/table_data.csv';

    // Create file object
    final file = File(filePath);

    // Read CSV file as string
    final csvString = await file.readAsString();

    // Convert CSV string to list
    final csvData = const CsvToListConverter().convert(csvString);

    if (csvData.length < 2) {
      return ImportStatus.emptyTable;
    }

    // Get headers and rows from CSV data
    final headers = csvData[0];
    final rows = csvData.sublist(1);

    // Empty DB if option is overriding.
    if (option == ImportOption.overrideTable) {
      final db = await database;
      db.delete(tableName);
      sqfliteDB = null;
    }

    // Get database instance
    final db = await database;
    final batch = db.batch();

    // Insert rows into database
    for (final record in rows) {
      final Map<String, dynamic> databaseRecord = {};

      for (var i = 0; i < headers.length; i++) {
        final header = headers[i];
        final value = record[i];

        databaseRecord[header] = value;
      }

      // Modify the id value before inserting into the SQLite table
      if (option == ImportOption.addToExistingTable) {
        final originalId = databaseRecord['id'];
        // Adding 'X' to avoid conflicts in table while inserting it.
        final modifiedId = 'X$originalId';
        databaseRecord['id'] = modifiedId;
      }

      batch.insert(tableName, databaseRecord);
    }

    await batch.commit();
    await db.close();

    // Return true to indicate successful import
    return ImportStatus.success;
  }

  // Function for debugging the import and export functions.
  void printTable() async {
    final database = await openDatabase(databaseName);
    final tableData = await database.query(tableName);

    print('--- Table Data: $tableData'); // Debug print statement

    final csvData = [[]];

    // Add header row
    csvData.add(tableData.first.keys.toList());

    // Add data rows
    for (final row in tableData) {
      csvData.add(row.values.toList());
    }

    // For some reason the first element might be empty so it should be removed
    // so that the table is able to convert to a string successfully below.
    if (csvData[0].isEmpty) {
      csvData.removeAt(0);
    }

    print('--- CSV data: $csvData'); // Debug print statement
  }
}
