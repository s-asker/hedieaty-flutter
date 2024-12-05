import 'package:flutter/material.dart';
import 'Model/Event.dart';
import 'Model/User.dart';
import 'Model/Gift.dart';
import 'gift_details_page.dart';
import 'profile_page.dart'; // Import ProfilePage

class CreateEventPage extends StatefulWidget {
  final User user;

  CreateEventPage({Key? key, required this.user}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<Gift> gifts = [];

  void _saveEvent() {
    // Create the event object
    final event = Event(
      id: DateTime.now().toString(),
      name: _nameController.text,
      date: DateTime.tryParse(_dateController.text) ?? DateTime.now(),
      giftList: gifts,
    );

    // Add the event to the user's events list
    setState(() {
      widget.user.events.add(event); // Save event to user's event list
    });

    // Navigate to ProfilePage after saving the event
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(user: widget.user), // Pass user with events
      ),
    );
  }

  void _addGift() {
    final newGift = Gift(
      name: "New Gift",
      description: "",
      category: "",
      price: 0.0,
      id: DateTime.now().toString(), // Generate unique ID
    );
    setState(() {
      gifts.add(newGift);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event/List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Event Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: "Event Date (YYYY-MM-DD)",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addGift,
              child: const Text("Add Gift"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: gifts.length,
                itemBuilder: (context, index) {
                  final gift = gifts[index];
                  return ListTile(
                    title: Text(gift.name),
                    subtitle: Text(gift.description.isNotEmpty ? gift.description : "No description"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GiftDetailsPage(gift: gift),
                        ),
                      ).then((updatedGift) {
                        if (updatedGift != null) {
                          setState(() {
                            int index = gifts.indexWhere((gift) => gift.id == updatedGift.id);
                            if (index != -1) {
                              gifts[index] = updatedGift; // Replace with updated gift
                            }
                          });
                        }
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveEvent,
              child: const Text("Save Event"),
            ),
          ],
        ),
      ),
    );
  }
}
