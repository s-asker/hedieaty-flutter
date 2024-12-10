import 'package:flutter/material.dart';
import 'Model/User.dart';
import 'Model/Friend.dart';
import 'Model/Event.dart';
import 'sqlite/database_helper.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(MyApp());
}

Future<void> initializeDatabase() async {
  final dbHelper = DatabaseHelper();

  final users = await dbHelper.fetchUsers();
  if (users.isEmpty) {
    print("No users found, inserting dummy data...");

    // Add dummy user
    await dbHelper.insertUser({
      'id': '123',
      'name': 'John Doe',
      'email': 'john@example.com',
      'preferences': 'Default preferences',
    });

    // Add dummy events for the user
    await dbHelper.insertEvent({
      'id': '1',
      'name': 'Birthday Party',
      'date': DateTime.now().toIso8601String(),
      'location': 'Venue 1',
      'description': 'A birthday celebration',
      'userId': '123',
    });

    // Add dummy friends
    await dbHelper.insertFriend({
      'userId': '123',
      'friendId': '1',
      'friendName': 'Jane Doe',
    });

    // Add friend's events
    await dbHelper.insertEvent({
      'id': '2',
      'name': 'Anniversary',
      'date': DateTime.now().add(Duration(days: 30)).toIso8601String(),
      'location': 'Venue 2',
      'description': 'Wedding anniversary event',
      'userId': '1',
    });

    print("Dummy data inserted.");
  } else {
    print("Users found: ${users.length}");
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
            return const Center(child: Text("No user data found."));
          }

          final data = snapshot.data!;
          final user = User.fromMap(
            data['user'],
            data['friends'],
            data['events'],
          );

          return HomePage(user: user, friends: user.friends);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getUserWithDetails() async {
    final dbHelper = DatabaseHelper();
    final userList = await dbHelper.fetchUsers();

    if (userList.isEmpty) {
      throw Exception("No users found in the database.");
    }

    final user = userList.first;
    final friendsList = await dbHelper.fetchFriends(user['id']);
    final eventsList = await dbHelper.fetchEvents(user['id']);

    final friends = friendsList.map((friend) => Friend.fromMap(friend)).toList();
    final events = eventsList.map((event) => Event.fromMap(event)).toList();

    return {
      'user': user,
      'friends': friends,
      'events': events,
    };
  }
}