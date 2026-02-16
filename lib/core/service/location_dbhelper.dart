import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocationDBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'locations.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE locations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          userId TEXT,
          locationData TEXT
        )
      ''');
    });
  }

  static Future<void> insertOrUpdateLocation(String userId, String locationString) async {
    final db = await database;
    final existing = await db.query('locations', where: 'userId = ?', whereArgs: [userId]);
    if (existing.isNotEmpty) {
      await db.update('locations', {'locationData': locationString}, where: 'userId = ?', whereArgs: [userId]);
    } else {
      await db.insert('locations', {'userId': userId, 'locationData': locationString});
    }
  }

  static Future<String> getLocationData(String userId) async {
    final db = await database;
    final result = await db.query('locations', where: 'userId = ?', whereArgs: [userId]);
    return result.isNotEmpty ? result.first['locationData'] as String : '';
  }
}