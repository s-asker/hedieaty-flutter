import 'package:flutter/material.dart';
import 'Model/User.dart'; // Import the User model
import 'Model/Event.dart'; // Import the Event model
import 'Model/Gift.dart'; // Import the Gift model
import 'create_event_page.dart';
import 'event_details_page.dart';
import 'gift_details_page.dart';
import 'my_pledged_gifts.dart'; // Import the Gift model

class ProfilePage extends StatefulWidget {
  final User user;

  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Event"),
          content: const Text("Would you like to create a new event?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateEventPage(user: user),
                  ),
                );
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  // Remove Event logic
  void _removeEvent(int index) {
    setState(() {
      user.events.removeAt(index); // Remove the event at the given index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${user.name}'s Profile",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: Text(
                "Name: ${user.name}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text("Tap to edit your name"),
              onTap: () {
                _showEditProfileDialog();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Created Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: user.events.length,
                itemBuilder: (context, index) {
                  final event = user.events[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        event.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Gifts: ${event.giftList.length}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: Colors.teal),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailsPage(event: event),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _removeEvent(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _showAddEventDialog,
              child: const Text("Add Event"),
            ),
          ],
        ),
      ),
    );

  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: TextField(
            controller: TextEditingController(text: user.name),
            decoration: const InputDecoration(labelText: "Name"),
            onChanged: (value) {
              setState(() {
                user.name = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}


