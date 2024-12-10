import 'package:flutter/material.dart';
import 'Model/Event.dart';
import 'Model/Friend.dart'; // Import Friend model
import 'profile_page.dart'; // Import the ProfilePage
import 'friends_event_list_page.dart'; // Import the FriendEventListPage
import 'Model/User.dart'; // Import the User model
import 'create_event_page.dart';
import 'sqlite/database_helper.dart'; // Import the CreateEventPage

class HomePage extends StatelessWidget {
  final List<Friend> friends;
  final User user;

  HomePage({Key? key, required this.friends, required this.user}) : super(key: key);

  Future<List<Friend>> fetchFriends() async {
    final dbHelper = DatabaseHelper();
    // Fetch friends for the current user
    final friendsData = await dbHelper.fetchFriends(user.id);

    // Populate each friend's events
    List<Friend> friends = [];
    for (var friendData in friendsData) {
      Friend friend = Friend.fromMap(friendData);
      final eventsData = await dbHelper.fetchEvents(friend.id);
      friend.upcomingEvents.addAll(
        eventsData.map((eventData) => Event.fromMap(eventData)),
      );
      friends.add(friend);
    }
    return friends;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hedieaty"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
              );
            },
          ),
        ],
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
            child: FutureBuilder<List<Friend>>(
              future: fetchFriends(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No friends found."));
                }

                final friends = snapshot.data!;
                return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    final friend = friends[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(friend.name[0].toUpperCase()),
                      ),
                      title: Text(friend.name),
                      subtitle: Text(
                        friend.upcomingEvents.isNotEmpty
                            ? "Upcoming Events: ${friend.upcomingEvents.length}"
                            : "No Upcoming Events",
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FriendEventListPage(friend: friend, user: user),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _addFriendDialog(context),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _addFriendDialog(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Friend",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final dbHelper = DatabaseHelper();
              // Add friend to database
              await dbHelper.insertFriend({
                'userId': user.id,
                'friendId': phoneController.text, // Simplified
                'friendName': 'New Friend', // Default name
              });
              Navigator.pop(context);
            },
            child: const Text("Add Friend"),
          ),
        ],
      ),
    );
  }
}
