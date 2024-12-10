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

  Future<List<Map<String, dynamic>>> fetchFriendsAsUsers(String userId) async {
    final db = await database; // Assuming 'database' is your database helper

    // Fetch friends of the user
    final List<Map<String, dynamic>> friends = await db.query(
      'friends',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    // Debug: Check the output of the friends query
    print("Fetched friends from DB: $friends");

    // If there are no friends, return an empty list
    if (friends.isEmpty) {
      print("No friends found.");
      return [];
    }

    // List to hold user data
    List<Map<String, dynamic>> friendAsUsers = [];

    // Loop through each friend and query the users table for the friend data
    for (var friend in friends) {
      final friendId = friend['friendId'];
      print("where is $friendId");
      // Query the users table to fetch the friend details
      final List<Map<String, dynamic>> user = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [friendId],
      );
      print("users are $user");

      // Add the friend data to the list
      if (user.isNotEmpty) {
        friendAsUsers.add(user.first);
      }
    }

    // Debug: Check the output of the users query
    print("Fetched users who are friends: $friendAsUsers");

    return friendAsUsers;
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
