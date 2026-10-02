import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../../core/constants/app_constants.dart';
import '../models/calculation_record.dart';

class HistoryDatabaseHelper {
  static final HistoryDatabaseHelper instance = HistoryDatabaseHelper._internal();
  HistoryDatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${AppConstants.historyTable} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expression TEXT NOT NULL,
            result TEXT NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertRecord(CalculationRecord record) async {
    try {
      final db = await database;
      return await db.insert(
        AppConstants.historyTable,
        record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      return -1;
    }
  }

  Future<List<CalculationRecord>> getAllRecords() async {
    try {
      final db = await database;
      final maps = await db.query(
        AppConstants.historyTable,
        orderBy: 'id DESC',
        limit: 100,
      );
      return maps.map((e) => CalculationRecord.fromMap(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<int> deleteRecord(int id) async {
    try {
      final db = await database;
      return await db.delete(
        AppConstants.historyTable,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (_) {
      return 0;
    }
  }

  Future<int> clearAll() async {
    try {
      final db = await database;
      return await db.delete(AppConstants.historyTable);
    } catch (_) {
      return 0;
    }
  }
}
