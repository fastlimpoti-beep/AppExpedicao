import 'package:app_separacao/database/db_schema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('separacao.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, fileName);

      await deleteDatabase(path);

      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      // print('Erro ao inicializar o banco: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await DBSchema.createTables(db);
  }

  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
      _database = null;
    }
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'separacao.db');
    await deleteDatabase(path);
    _database = await _initDB('separacao.db');
  }
}
