import 'package:flutter/material.dart';
import 'Model/Friend.dart'; // Import Friend model
import 'profile_page.dart'; // Import the ProfilePage
import 'friends_event_list_page.dart'; // Import the FriendEventListPage
import 'Model/User.dart'; // Import the User model
import 'create_event_page.dart'; // Import the CreateEventPage

class HomePage extends StatelessWidget {
  final List<Friend> friends;
  final User user; // Add User to the HomePage

  HomePage({Key? key, required this.friends, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hedieaty"),
        actions: [
          // Button to navigate to the Profile Page
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              debugPrint("PledgedGiftsPage User ID: ${user.id}");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(user: user)), // Pass user to ProfilePage
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display user's events
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to the CreateEventPage and pass the user
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEventPage(user: user), // Pass the user object
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text("Create Your Own Event/List"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          // List of friends
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return ListTile(
                  leading: CircleAvatar(
                    // Use a placeholder image for now
                    // backgroundImage: AssetImage('assets/images/placeholder.png'),
                  ),
                  title: Text(friend.name),
                  subtitle: Text(
                    friend.upcomingEventsCount > 0
                        ? "Upcoming Events: ${friend.upcomingEventsCount}"
                        : "No Upcoming Events",
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to Friend's Event List Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendEventListPage(friend: friend, user: user), // Pass friend object
                      ),
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
            builder: (context) => _addFriendDialog(),
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _addFriendDialog() {
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
          const TextField(
            decoration: InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Logic to add friend
            },
            child: const Text("Add Friend"),
          ),
        ],
      ),
    );
  }
}
