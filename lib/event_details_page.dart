import 'package:flutter/material.dart';
import 'Model/Event.dart'; // Import the Event model
import 'Model/Gift.dart';
import 'gift_details_page.dart'; // Import the Gift model

class EventDetailsPage extends StatefulWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late Event event;

  @override
  void initState() {
    super.initState();
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Gifts for This Event",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: event.giftList.length,
                itemBuilder: (context, index) {
                  final gift = event.giftList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(gift.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            event.giftList.removeAt(index);
                          });
                        },
                      ),
                      onTap: () {
                        // Navigate to GiftDetailsPage for editing the gift
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GiftDetailsPage(gift: gift),
                          ),
                        ).then((updatedGift) {
                          if (updatedGift != null) {
                            setState(() {
                              event.giftList[index] = updatedGift; // Update the gift
                            });
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addGift();
              },
              child: const Text("Add Gift"),
            ),
          ],
        ),
      ),
    );
  }

  void _addGift() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GiftDetailsPage(gift: Gift(name: '', description: '', price: 0.0, id: '')), // Empty gift for adding
      ),
    ).then((newGift) {
      if (newGift != null) {
        setState(() {
          event.giftList.add(newGift); // Add the new gift to the event's gift list
        });
      }
    });
  }
}
