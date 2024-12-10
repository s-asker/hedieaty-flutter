import 'package:flutter/material.dart';
import 'Model/User.dart'; // Import User model
import 'friends_event_list_page.dart'; // Import FriendEventListPage
import 'create_event_page.dart';
import 'sqlite/database_helper.dart'; // Import DatabaseHelper

class HomePage extends StatelessWidget {
  final User user;
  final List<User> friends;

  HomePage({Key? key, required this.user, required this.friends}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hedieaty"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
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
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      (friend.name?.isNotEmpty ?? false)
                          ? friend.name![0].toUpperCase()
                          : '?', // Default to '?' if name is null or empty
                    ),
                  ),
                  title: Text(
                    friend.name ?? 'Unnamed Friend', // Provide a default value if name is null
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addFriendDialog(context);
        },
        child: const Icon(Icons.person_add),
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
