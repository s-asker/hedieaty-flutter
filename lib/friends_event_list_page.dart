import 'package:flutter/material.dart';
import 'Model/Friend.dart';
import 'Model/Event.dart';
import 'Model/User.dart';
import 'gift_list_page.dart'; // Import the GiftListPage

class FriendEventListPage extends StatefulWidget {
  final User user; // Pass the user object to keep track of pledged gifts

  FriendEventListPage({required this.user});

  @override
  _FriendEventListPageState createState() => _FriendEventListPageState();
}

class _FriendEventListPageState extends State<FriendEventListPage> {
  late List<Event> _friendEvents;

  @override
  void initState() {
    super.initState();
    // Ensure the friend's events are initialized
    _friendEvents = widget.user.events ?? [];
  }

  // Sort events by date
  void _sortByDate() {
    setState(() {
      _friendEvents.sort((a, b) => a.date.compareTo(b.date)); // Sorting by date
    });
  }

  // Sort events by status (Past, Current, Upcoming)
  void _sortByStatus() {
    setState(() {
      _friendEvents.sort((a, b) {
        // Define a custom priority for statuses
        const statusPriority = {'Past': 0, 'Current': 1, 'Upcoming': 2};
        return statusPriority[a.status]!.compareTo(statusPriority[b.status]!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.user.name}'s Events"),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortOptions();
            },
          ),
        ],
      ),
      body: _friendEvents.isEmpty
          ? const Center(child: Text("No events available."))
          : ListView.builder(
        itemCount: _friendEvents.length,
        itemBuilder: (context, index) {
          final event = _friendEvents[index];
          return ListTile(
            title: Text(event.name),
            subtitle: Text("Status: ${event.status}"),
            onTap: () {
              // Navigate to the Gift List Page for this event
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiftListPage(eventId: event.id), // Pass the event and user to GiftListPage
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Events'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('By Date'),
              onTap: () {
                _sortByDate();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('By Status'),
              onTap: () {
                _sortByStatus();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
