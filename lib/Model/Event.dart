import 'Gift.dart';

class Event {
  final String id; // Unique identifier for the event
  final String name; // Name of the event, e.g., "Birthday Party"
  final DateTime date; // Date of the event
  final List<Gift> giftList; // List of gifts associated with this event

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.giftList,
  });

  // Helper method to get the status of the event based on its date
  String get status {
    final now = DateTime.now();
    if (date.isBefore(now)) {
      return 'Past'; // Event has already passed
    } else if (date.isAtSameMomentAs(now)) {
      return 'Current'; // Event is today
    } else {
      return 'Upcoming'; // Event is in the future
    }
  }
}
