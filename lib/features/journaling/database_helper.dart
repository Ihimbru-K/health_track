import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


//a helper class that helps us perform crud operations with journal items
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

  //creates unique id, inputed text, mood and date data table for storing journal items
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

  ///stores journal item
  Future<int> insertEntry(Map<String, dynamic> entry) async {
    final db = await database;
    return db.insert('journal_entries', entry);
  }


  ///fetches journal item
  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await database;
    return db.query('journal_entries', orderBy: 'date DESC');
  }

  ///deletes journal item from sqlite db
  Future<int> deleteEntry(int id) async {
    final db = await database;
    return db.delete('journal_entries', where: 'id = ?', whereArgs: [id]);
  }
}


























