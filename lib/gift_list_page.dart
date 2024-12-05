import 'package:flutter/material.dart';
import 'Model/Gift.dart'; // Import the Gift model
import 'Model/Event.dart'; // Import the Event model
import 'Model/User.dart'; // Import the User model

class GiftListPage extends StatefulWidget {
  final Event event; // Receive the event whose gifts you want to display
  final User user; // Receive the user to update pledgedGifts

  GiftListPage({required this.event, required this.user});

  @override
  _GiftListPageState createState() => _GiftListPageState();
}

class _GiftListPageState extends State<GiftListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gifts for ${widget.event.name}"),
      ),
      body: ListView.builder(
        itemCount: widget.event.giftList.length,
        itemBuilder: (context, index) {
          final gift = widget.event.giftList[index];
          return ListTile(
            title: Text(gift.name),
            subtitle: Text(gift.status == 'available' ? 'Available' : 'Pledged'),
            trailing: Icon(gift.status == 'available' ? Icons.add_circle : Icons.check),
            onTap: () {
              // Handle tapping a gift to pledge or view details
              _pledgeGift(context, gift);
            },
          );
        },
      ),
    );
  }

  void _pledgeGift(BuildContext context, Gift gift) {
    if (gift.status == 'available') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pledge Gift: ${gift.name}"),
            content: Text("Do you want to pledge this gift?"),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    // Update gift status
                    gift.status = 'pledged';

                    // Add gift to pledgedGifts
                    widget.user.pledgedGifts ??= []; // Initialize list if null
                    widget.user.pledgedGifts!.add(gift);

                    // Debug log
                    debugPrint("Gift ${gift.name} pledged. Pledged gifts: ${widget.user.pledgedGifts!.map((g) => g.name).toList()}");
                  });
                  Navigator.pop(context);
                },
                child: const Text("Pledge"),
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${gift.name} has already been pledged!")),
      );
    }
    debugPrint("GiftListPage User ID: ${widget.user.id}");
    debugPrint("Pledged gifts in GiftListPage: ${widget.user.pledgedGifts?.map((gift) => gift.name).toList()}");
  }

}

