import 'Event.dart';

class Friend {
  final String id; // Unique identifier for the friend
  final String name;
  final List<Event> upcomingEvents; // List of events for the friend

  Friend({
    required this.id,
    required this.name,
    required this.upcomingEvents,
  });

  // Helper method to get a count of upcoming events
  int get upcomingEventsCount => upcomingEvents.length;
}
