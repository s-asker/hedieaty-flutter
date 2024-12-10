import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'hedieaty.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT,
        preferences TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE events (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        date TEXT,
        location TEXT,
        description TEXT,
        userId TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      );
    ''');
    await db.execute('''
      CREATE TABLE gifts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        status TEXT,
        category TEXT,
        price REAL,
        eventId TEXT NOT NULL,
        FOREIGN KEY (eventId) REFERENCES events (id) ON DELETE CASCADE
      );
    ''');
    await db.execute('''
      CREATE TABLE friends (
        userId TEXT NOT NULL,
        friendId TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (friendId) REFERENCES users (id) ON DELETE CASCADE
      );
    ''');
  }

  // Insert Methods
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    await db.insert('events', event, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertGift(Map<String, dynamic> gift) async {
    final db = await database;
    await db.insert('gifts', gift, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertFriend(Map<String, dynamic> friend) async {
    final db = await database;
    await db.insert('friends', friend, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Fetch Methods
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> fetchEvents(String userId) async {
    final db = await database;
    return await db.query('events', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<List<Map<String, dynamic>>> fetchGifts(String eventId) async {
    final db = await database;
    return await db.query('gifts', where: 'eventId = ?', whereArgs: [eventId]);
  }

  Future<List<Map<String, dynamic>>> fetchFriends(String userId) async {
    final db = await database;
    return await db.query('friends', where: 'userId = ?', whereArgs: [userId]);
  }

  // Helper to get friend details
  Future<List<Map<String, dynamic>>> fetchFriendDetails(String userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT u.* 
      FROM users u
      INNER JOIN friends f ON u.id = f.friendId
      WHERE f.userId = ?;
    ''', [userId]);
  }
}
