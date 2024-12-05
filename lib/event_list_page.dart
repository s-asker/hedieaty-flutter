import 'package:flutter/material.dart';
import 'Model/Friend.dart';
import 'Model/Event.dart';
import 'Model/Gift.dart';  // Import the Gift model if needed

class EventListPage extends StatefulWidget {
  final Friend friend;

  EventListPage({Key? key, required this.friend}) : super(key: key);

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  late List<Event> _events;

  @override
  void initState() {
    super.initState();
    _events = widget.friend.upcomingEvents;  // Initialize the events list
  }

  // Function to get event status (Upcoming, Current, Past)
  String _getEventStatus(DateTime date) {
    if (date.isBefore(DateTime.now())) {
      return 'Past';
    } else if (date.isAtSameMomentAs(DateTime.now())) {
      return 'Current';
    } else {
      return 'Upcoming';
    }
  }

  // Sort events by name
  void _sortByName() {
    setState(() {
      _events.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  // Sort events by date
  void _sortByDate() {
    setState(() {
      _events.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  // Sort events by status
  void _sortByStatus() {
    setState(() {
      _events.sort((a, b) => _getEventStatus(a.date).compareTo(_getEventStatus(b.date)));
    });
  }

  // Handle event deletion
  void _deleteEvent(Event event) {
    setState(() {
      _events.remove(event);
    });
  }

  // Handle event addition
  void _addEvent() {
    // Logic to add a new event (e.g., show a dialog or navigate to another page)
    setState(() {
      _events.add(
        Event(
          id: 'new_id',
          name: 'New Event',
          date: DateTime.now(),
          giftList: [],
        ),
      );
    });
  }

  // Handle event editing
  void _editEvent(Event event) {
    // Logic to edit an event (e.g., show a dialog or navigate to another page)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.friend.name}'s Events"),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Sort Events'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('By Name'),
                        onTap: () {
                          _sortByName();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('By Date'),
                        onTap: () {
                          _sortByDate();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('By Status'),
                        onTap: () {
                          _sortByStatus();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Button to create a new event
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _addEvent,
              icon: const Icon(Icons.add),
              label: const Text("Add New Event"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          // List of events
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text("${_getEventStatus(event.date)} - ${event.date.toString()}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editEvent(event),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteEvent(event),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to Gift List Page (for the selected event)
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
