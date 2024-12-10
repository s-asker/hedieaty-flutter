import 'package:flutter/material.dart';
import 'Model/User.dart'; // Import the User model
import 'Model/Event.dart'; // Import the Event model
import 'Model/Gift.dart'; // Import the Gift model
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
    final _eventNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add New Event"),
          content: TextField(
            controller: _eventNameController,
            decoration: const InputDecoration(labelText: "Event Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  user.events.add(Event(name: _eventNameController.text, giftList: [], id: '', date: DateTime.now(), description: ''));
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
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
        title: Text("${user.name}'s Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Name: ${user.name}"),
              subtitle: const Text("Tap to edit your name"),
              onTap: () {
                _showEditProfileDialog();
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Your Created Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: user.events.length,
                itemBuilder: (context, index) {
                  final event = user.events[index];
                  return ListTile(
                    title: Text(event.name),
                    subtitle: Text("Gifts: ${event.giftList.length}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Navigate to EventDetailsPage
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailsPage(event: event),
                              ),
                            );
                          },
                        ),
                        // Remove Event Button
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _removeEvent(index); // Remove event at the index
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
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


