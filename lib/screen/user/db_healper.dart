import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class MeasurementDBHelper {
  static final MeasurementDBHelper _instance = MeasurementDBHelper._internal();
  factory MeasurementDBHelper() => _instance;
  MeasurementDBHelper._internal();

  static Database? _database;
  static const String _databaseName = 'measurements.db';
  static const int _databaseVersion = 1;
  static const String _tableName = 'measurements';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, _databaseName);
    debugPrint('Database path: $dbPath'); // Log the database path

    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: (db, version) async {
        debugPrint('Creating table $_tableName...');
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT NOT NULL, -- Ensure userId is not null
            chest REAL,
            waist REAL,
            hips REAL,
            inseam REAL,
            date TEXT NOT NULL -- Ensure date is not null
          )
        ''');
        debugPrint('Table $_tableName created successfully.');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // This is important for schema changes in future versions
        debugPrint('Upgrading database from version $oldVersion to $newVersion...');
        if (oldVersion < 1) {
          // Example: If you add new columns in a future version (e.g., version 2)
          // You would add ALTER TABLE statements here
          // e.g., await db.execute("ALTER TABLE $_tableName ADD COLUMN newColumn TEXT");
        }
        // If you had oldVersion 1 and upgraded to newVersion 2, you'd add:
        // if (oldVersion < 2) {
        //   await db.execute("ALTER TABLE $_tableName ADD COLUMN someNewField TEXT");
        // }
      },
    );
  }

  Future<int> insertMeasurement(Map<String, dynamic> data) async {
    final db = await database;
    try {
      final id = await db.insert(_tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
      debugPrint('Inserted measurement with id: $id, data: $data');
      return id;
    } catch (e) {
      debugPrint('Error inserting measurement: $e, data: $data');
      rethrow; // Re-throw to allow calling widget to handle
    }
  }

  Future<List<Map<String, dynamic>>> getAllMeasurements(String userId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.query(
        _tableName,
        where: 'userId = ?',
        whereArgs: [userId],
        orderBy: 'date DESC',
      );
      debugPrint('Querying measurements for userId: $userId. Found ${result.length} entries.');
      return result;
    } catch (e) {
      debugPrint('Error querying measurements for userId $userId: $e');
      rethrow; // Re-throw to allow calling widget to handle
    }
  }

  Future<int> deleteMeasurement(int id) async {
    final db = await database;
    try {
      final count = await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint('Deleted $count measurement(s) with id: $id');
      return count;
    } catch (e) {
      debugPrint('Error deleting measurement with id $id: $e');
      rethrow;
    }
  }

  // Optional: Update measurement
  Future<int> updateMeasurement(Map<String, dynamic> data) async {
    final db = await database;
    try {
      final id = data['id'];
      final count = await db.update(
        _tableName,
        data,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Updated $count measurement(s) for id: $id, data: $data');
      return count;
    } catch (e) {
      debugPrint('Error updating measurement for id $e');
      rethrow;
    }
  }

  // Optional: Clear all measurements (useful for testing or specific user flows)
  Future<int> deleteAllMeasurements() async {
    final db = await database;
    try {
      final count = await db.delete(_tableName);
      debugPrint('Deleted all $count measurements from $_tableName.');
      return count;
    } catch (e) {
      debugPrint('Error deleting all measurements: $e');
      rethrow;
    }
  }
}