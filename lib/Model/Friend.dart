import 'Event.dart';

class Friend {
  final String id;
  final String name;
  final List<Event> upcomingEvents;

  Friend({
    required this.id,
    required this.name,
    required this.upcomingEvents,
  });

  factory Friend.fromMap(Map<String, dynamic> friendData) {
    String id = friendData['friendId'] as String? ?? '';
    String name = friendData['friendName'] as String? ?? 'Unknown';
    return Friend(
      id: id,
      name: name,
      upcomingEvents: (friendData['upcomingEvents'] as List<dynamic>? ?? [])
          .map((e) => Event.fromMap(e))
          .toList(),
    );
  }
}