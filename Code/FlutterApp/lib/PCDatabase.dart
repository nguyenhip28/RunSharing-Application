import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PCDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'pc.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE pcs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          category TEXT,
          date TEXT,
          ram TEXT,
          cpu TEXT,
          price TEXT
        )
      ''');
    });
  }

  static Future<void> savePC(Map<String, dynamic> pc) async {
    final db = await database;
    await db.insert('pcs', pc);
  }

  static Future<List<Map<String, dynamic>>> getPCs() async {
    final db = await database;
    return await db.query('pcs', orderBy: 'date DESC');
  }

  static Future<void> deletePC(int id) async {
    final db = await database;
    await db.delete('pcs', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteAll() async {
    final db = await database;
    await db.delete('pcs');
  }
  static Future<void> updatePC(int id, Map<String, dynamic> pc) async {
    final db = await database;
    await db.update('pcs', pc, where: 'id = ?', whereArgs: [id]);
  }
}
