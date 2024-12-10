import 'Gift.dart';

class Event {
  final String id;
  final String name;
  final DateTime date;
  final String description;
  final List<Gift> giftList;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.giftList,
    required this.description
  });

  factory Event.fromMap(Map<String, dynamic> event) {
    return Event(
      id: event['id'] as String,
      name: event['name'] as String,
      date: DateTime.parse(event['date']),
      description: event['description'] as String,
      giftList: [], // Populate with fetchGifts if needed
    );
  }
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
