import 'package:flutter/material.dart';
import 'Model/User.dart'; // Import User model
import 'friends_event_list_page.dart'; // Import FriendEventListPage
import 'create_event_page.dart';
import 'sqlite/database_helper.dart'; // Import DatabaseHelper
import 'profile_page.dart'; // Import ProfilePage

class HomePage extends StatelessWidget {
  final User user;
  final List<User> friends;

  HomePage({Key? key, required this.user, required this.friends}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hedieaty",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Profile",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Button color
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateEventPage(user: user)),
                  );
                },
                child: const Text("Create Your Own Event/List"),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  final upcomingEventsCount = friend.events
                      .where((event) => event.date.isAfter(DateTime.now()))
                      .length;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal[300],
                        child: Text(
                          (friend.name?.isNotEmpty ?? false)
                              ? friend.name![0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        friend.name ?? 'Unnamed Friend',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text('$upcomingEventsCount upcoming event(s)'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () {
          _addFriendDialog(context);
        },
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );

  }

  void _addFriendDialog(BuildContext context) {
    final TextEditingController friendIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Friend"),
          content: TextField(
            controller: friendIdController,
            decoration: const InputDecoration(
              labelText: "Friend ID",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final dbHelper = DatabaseHelper();
                // Add friend relationship
                await dbHelper.insertFriend({
                  'userId': user.id,
                  'friendId': friendIdController.text,
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
