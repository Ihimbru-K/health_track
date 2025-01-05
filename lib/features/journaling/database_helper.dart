import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'journal.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE journal_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            mood TEXT,
            date TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  Future<int> insertEntry(Map<String, dynamic> entry) async {
    final db = await database;
    return db.insert('journal_entries', entry);
  }

  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await database;
    return db.query('journal_entries', orderBy: 'date DESC');
  }

  Future<int> deleteEntry(int id) async {
    final db = await database;
    return db.delete('journal_entries', where: 'id = ?', whereArgs: [id]);
  }
}


























// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// import 'journal_entry.dart';
//
//
// class DatabaseService {
//   static final DatabaseService _instance = DatabaseService._internal();
//   factory DatabaseService() => _instance;
//
//   static Database? _database;
//
//   DatabaseService._internal();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     final path = join(await getDatabasesPath(), 'journal.db');
//     return openDatabase(
//       path,
//       onCreate: (db, version) {
//         return db.execute(
//           'CREATE TABLE journal(id INTEGER PRIMARY KEY, text TEXT, mood TEXT, date TEXT)',
//         );
//       },
//       version: 1,
//     );
//   }
//
//   Future<void> insertJournalEntry(JournalEntry entry) async {
//     final db = await database;
//     await db.insert('journal', entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   Future<List<JournalEntry>> getAllJournalEntries() async {
//     final db = await database;
//     final maps = await db.query('journal');
//     return List.generate(
//       maps.length,
//           (i) => JournalEntry.fromMap(maps[i]),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
