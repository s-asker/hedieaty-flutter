import 'Event.dart';
import 'Gift.dart';

class User {
  final String id;
  String? name; // Nullable
  final String? email; // Nullable
  final List<User> friends;
  final List<Event> events;
  List<Gift>? pledgedGifts = [];

  User({
    required this.id,
    this.name,
    this.email,
    required this.friends,
    required this.events,
  });

  factory User.fromMap(
      Map<String, dynamic> user,
      List<User> friends,
      List<Event> events,
      ) {
    return User(
      id: user['id'] ?? '', // Provide fallback empty string if null
      name: user['name'],   // Nullable, no need for a fallback
      email: user['email'], // Nullable, no need for a fallback
      friends: friends,
      events: events,
    );
  }
}
