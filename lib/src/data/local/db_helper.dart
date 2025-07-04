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

  static Future _onCreate(Database db, int version) async {
    // Tabel pengguna tidak berubah
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE watchlist (
        userId INTEGER NOT NULL,
        movieId INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        PRIMARY KEY (userId, movieId)
      )
    ''');
  }

  // ~~~~~~ USER METHOD ~~~~~~
  static Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? User.fromJson(result.first) : null;
  }

  static Future<int> checkUser(String username) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.length;
  }

  // ==== METHOD WATCHLIST ====

  // Menambahkan film ke watchlist pengguna
  static Future<void> addMovieToWatchlist(int userId, int movieId) async {
    final db = await database;
    await db.insert(
      'watchlist',
      {'userId': userId, 'movieId': movieId},
      conflictAlgorithm: ConflictAlgorithm.ignore, // Abaikan jika sudah ada
    );
  }

  // Menghapus film dari watchlist pengguna
  static Future<void> removeMovieFromWatchlist(int userId, int movieId) async {
    final db = await database;
    await db.delete(
      'watchlist',
      where: 'userId = ? AND movieId = ?',
      whereArgs: [userId, movieId],
    );
  }

  // Mendapatkan semua ID film dari watchlist seorang pengguna
  static Future<List<int>> getWatchlist(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'watchlist',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return maps[i]['movieId'] as int;
    });
  }
}
