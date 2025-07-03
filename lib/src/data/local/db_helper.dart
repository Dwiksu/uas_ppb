import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:uas_ril/src/data/models/user.dart';

class DbHelper {
  static Database? _db;
  static const _dbName = "movie_app.db";

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Membuat semua tabel di sini
  static Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // await db.execute('''
  //   CREATE TABLE watchlist (
  //     id INTEGER PRIMARY KEY AUTOINCREMENT,
  //     userId INTEGER,
  //     title TEXT NOT NULL,
  //     FOREIGN KEY (userId) REFERENCES users (id)
  //   )
  // ''');

  // ~~~~~~ USER METHOD ~~~~~~
  static Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint("Berhasil Menambahkan User");
  }

  static Future<User> getUserById(int id) async {
    final db = await database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return User.fromJson(result.first);
  }

  static Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    } else {
      return null;
    }
  }

  // Check Username
  static Future<int> checkUser(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.length;
  }

  static Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}
