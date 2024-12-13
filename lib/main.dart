import 'package:flutter/material.dart';
import 'Model/User.dart'; // Import User model
import 'Model/Event.dart';
import 'Model/Gift.dart';
import 'home_page.dart';
import 'sqlite/database_helper.dart'; // Import DatabaseHelper

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required for async initialization
  await initializeDatabase(); // Call database initialization
  runApp(MyApp());

}

Future<void> initializeDatabase() async {
  final dbHelper = DatabaseHelper();

  // Check if the database is empty
  final users = await dbHelper.fetchUsers();
  print("Existing users: $users"); // Debugging log
  if (users.isEmpty) {
    print("No users found, inserting dummy data...");

    // Add dummy user
    await dbHelper.insertUser({
      'id': '123',
      'name': 'John Doe',
      'email': 'john@example.com',
      'preferences': 'Default preferences',
    });

    // Add dummy friend
    await dbHelper.insertUser({
      'id': '124',
      'name': 'Jane Doe',
      'email': 'jane@example.com',
      'preferences': 'Default preferences',
    });
    await dbHelper.insertUser({
      'id': '125',
      'name': 'Jd Doe',
      'email': 'jane@example.com',
      'preferences': 'Default preferences',
    });
    await dbHelper.insertUser({
      'id': '126',
      'name': 'Jass Doe',
      'email': 'jane@example.com',
      'preferences': 'Default preferences',
    });
    await dbHelper.insertFriend({
      'userId': '123', // The ID of the current user
      'friendId': '124', // The ID of the friend
    });
    // Add events for user and friend
    await dbHelper.insertEvent({
      'id': '1',
      'name': 'John\'s Birthday Party',
      'date': DateTime.now().toIso8601String(),
      'location': 'Venue 1',
      'description': 'John\'s celebration event',
      'userId': '124',
    });
    await dbHelper.insertEvent({
      'id': '1',
      'name': 'John\'s Birthday Party',
      'date': DateTime.now().toIso8601String(),
      'location': 'Venue 1',
      'description': 'John\'s celebration event',
      'userId': '123',
    });

    await dbHelper.insertEvent({
      'id': '2',
      'name': 'Jane\'s Graduation Party',
      'date': DateTime.now().toIso8601String(),
      'location': 'Venue 2',
      'description': 'Jane\'s graduation celebration',
      'userId': '124',
    });

    print("Dummy data inserted.");
  } else {
    print("Users found: ${users.length}"); // Debugging log
  }
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<Map<String, dynamic>>(
        future: _getUserWithDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            print("Snapshot has no data: ${snapshot.error}");
            return const Center(child: Text("No user data found."));
          }

          final data = snapshot.data!;
          print("Snapshot data: $data");

          final user = User.fromMap(
            data['user'],
            data['friends'],
            data['events'],
          );

          return HomePage(user: user, friends: data['friends']);
        },
      ),
    );
  }

  // Fetch user with details and their friends from the user table
  Future<Map<String, dynamic>> _getUserWithDetails() async {
    final dbHelper = DatabaseHelper();

    // Fetch main user
    final userList = await dbHelper.fetchUsers();
    print("Fetched users: $userList"); // Debugging log

    if (userList.isEmpty) {
      throw Exception("No users found in the database.");
    }

    final user = userList.first;
    print("Selected user: $user"); // Debugging log

    // Fetch user's friends (other users)
    final friendsList = await dbHelper.fetchFriendsAsUsers(user['id']); // Adjusted to fetch from users
    final eventsList = await dbHelper.fetchEvents(user['id']);

    print("Fetched friends: $friendsList"); // Debugging log
    print("Fetched events: $eventsList"); // Debugging log

    // Convert friends and events to User and Event model objects
    final friends = friendsList.map((friend) => User.fromMap(friend, [], [])).toList();
    final events = eventsList.map((event) => Event.fromMap(event)).toList();
    print(friends[0].email);

    return {
      'user': user,
      'friends': friends,
      'events': events,
    };
  }

}
