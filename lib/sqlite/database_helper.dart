import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    String path = join(await getDatabasesPath(), 'hedieaty.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        preferences TEXT
      )
    ''');

    // Create Events table
    await db.execute('''
      CREATE TABLE events (
        id TEXT PRIMARY KEY,
        name TEXT,
        date TEXT,
        location TEXT,
        description TEXT,
        userId TEXT,
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Create Gifts table
    await db.execute('''
      CREATE TABLE gifts (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        category TEXT,
        price REAL,
        status TEXT,
        eventId TEXT,
        FOREIGN KEY (eventId) REFERENCES events (id) ON DELETE CASCADE
      )
    ''');

    // Create Friends table
    await db.execute('''
      CREATE TABLE friends (
        userId TEXT,
        friendId TEXT,
        PRIMARY KEY (userId, friendId),
        FOREIGN KEY (userId) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (friendId) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }

  // Insert User
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert Event
  Future<void> insertEvent(Map<String, dynamic> event) async {
    final db = await database;
    await db.insert('events', event, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert Gift
  Future<void> insertGift(Map<String, dynamic> gift) async {
    final db = await database;
    await db.insert('gifts', gift, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert Friend
  Future<void> insertFriend(Map<String, dynamic> friend) async {
    final db = await database;
    await db.insert('friends', friend, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Fetch all Users
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Fetch all Events for a User
  Future<List<Map<String, dynamic>>> fetchEvents(String userId) async {
    final db = await database;
    return await db.query('events', where: 'userId = ?', whereArgs: [userId]);
  }

  // Fetch all Gifts for an Event
  Future<List<Map<String, dynamic>>> fetchGifts(String eventId) async {
    final db = await database;
    return await db.query('gifts', where: 'eventId = ?', whereArgs: [eventId]);
  }

  // Delete Event
  Future<void> deleteEvent(String eventId) async {
    final db = await database;
    await db.delete('events', where: 'id = ?', whereArgs: [eventId]);
  }

  // Delete Gift
  Future<void> deleteGift(String giftId) async {
    final db = await database;
    await db.delete('gifts', where: 'id = ?', whereArgs: [giftId]);
  }


  // Delete User
  Future<void> deleteUser(String userId) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [userId]);
  }

  // Delete Friend
  Future<void> deleteFriend(String userId, String friendId) async {
    final db = await database;
    await db.delete('friends',
        where: 'userId = ? AND friendId = ?', whereArgs: [userId, friendId]);
  }

}
