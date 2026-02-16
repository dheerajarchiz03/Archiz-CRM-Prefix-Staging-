import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MapLabels {
  String? id;
  String? userID;
  String? count;
  String? location;
  String? gpsStatus;
  String? internetStatus;

  MapLabels({
    this.id,
    this.userID,
    this.count,
    this.location,
    this.gpsStatus,
    this.internetStatus,
  });

  factory MapLabels.fromMap(Map<String, dynamic> map) => MapLabels(
        id: map['id']?.toString(),
        userID: map['userid'],
        count: map['count'],
        location: map['location'],
        gpsStatus: map['gpsStatus'],
        internetStatus: map['internetStatus'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userid': userID,
        'count': count,
        'location': location,
        'gpsStatus': gpsStatus,
        'internetStatus': internetStatus,
      };
}

class MapLocalDataBase {
  static final MapLocalDataBase _instance = MapLocalDataBase._internal();
  static Database? _database;

  static const String _dbName = "ADMINLOCATION.db";
  static const int _dbVersion = 1;
  static const String tableLocation = "adminlocation";

  static const String keyId = "id";
  static const String keyUserId = "userid";
  static const String keyCount = "count";
  static const String keyGpsStatus = "gpsStatus";
  static const String keyInternetStatus = "internetStatus";
  static const String keyLocation = "location";

  MapLocalDataBase._internal();

  factory MapLocalDataBase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableLocation (
            $keyId INTEGER PRIMARY KEY AUTOINCREMENT,
            $keyUserId TEXT,
            $keyCount TEXT,
            $keyGpsStatus TEXT,
            $keyInternetStatus TEXT,
            $keyLocation TEXT
          )
        ''');
      },
    );
  }
  // CRUD Methods
  Future<bool> isEmpty() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $tableLocation'),
    );
    return (count ?? 0) == 0;
  }
  Future<bool> isExist(String userId) async {
    final db = await database;
    final result = await db.query(
      tableLocation,
      where: '$keyUserId = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty;
  }
  Future<void> insertLocation(MapLabels labels) async {
    final db = await database;
    await db.insert(tableLocation, labels.toMap());
  }

  Future<bool> updateContact(MapLabels labels) async {
    final db = await database;
    final count = await db.update(
      tableLocation,
      labels.toMap(),
      where: '$keyUserId = ?',
      whereArgs: [labels.userID],
    );
    return count > 0;
  }

  Future<bool> updateLocation(MapLabels labels) async {
    final db = await database;
    final count = await db.update(
      tableLocation,
      {
        keyUserId: labels.userID,
        keyLocation: labels.location,
      },
      where: '$keyUserId = ?',
      whereArgs: [labels.userID],
    );
    return count > 0;
  }

  Future<List<MapLabels>> getDataByUser(String userId) async {
    final db = await database;
    final result = await db.query(
      tableLocation,
      where: '$keyUserId = ?',
      whereArgs: [userId],
    );
    return result.map((e) => MapLabels.fromMap(e)).toList();
  }

  Future<void> deleteLocationTable() async {
    final db = await database;
    await db.delete(tableLocation);
  }

  Future<void> deleteLocationData() async {
    final db = await database;
    await db.delete(tableLocation);
  }

  Future<void> deleteDataBase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
  }

  Future<List<MapLabels>> getAllLabels() async {
    final db = await database;
    final result = await db.query(tableLocation);
    return result.map((e) => MapLabels.fromMap(e)).toList();
  }

  Future<bool> updateStatus(String userId, String status) async {
    final db = await database;
    final count = await db.update(
      tableLocation,
      {keyGpsStatus: status},
      where: '$keyUserId = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  Future<Object> getStatusGPS(String userId) async {
    final db = await database;
    final result = await db.query(
      tableLocation,
      columns: [keyGpsStatus],
      where: '$keyUserId = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first[keyGpsStatus] ?? '';
    }
    return '';
  }

  Future<bool> updateInternetStatus(String userId, String status) async {
    final db = await database;
    final count = await db.update(
      tableLocation,
      {keyInternetStatus: status},
      where: '$keyUserId = ?',
      whereArgs: [userId],
    );
    return count > 0;
  }

  Future<Object> getStatusInternet(String userId) async {
    final db = await database;
    final result = await db.query(
      tableLocation,
      columns: [keyInternetStatus],
      where: '$keyUserId = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first[keyInternetStatus] ?? '';
    }
    return '';
  }
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
