import 'Gift.dart';
import 'Friend.dart';
import 'Event.dart';

class User {
  final String id;
  String name;
  final String email;
  final List<Friend> friends;
  final List<Event> events;
  List<Gift>? pledgedGifts = [];

  User({
    required this.id,
    required this.name,
    required this.friends,
    required this.events,
    required this.email,
  });

  factory User.fromMap(
      Map<String, dynamic> user,
      List<Friend> friends,
      List<Event> events,
      ) {

    String id = user['id'] as String? ?? '';  // Provide a fallback empty string if null
    String name = user['name'] as String? ?? '';  // Provide a fallback empty string if null
    String email = user['email'] as String ?? '';
    return User(
      id: id,
      name: name,
      email: email,
      friends: friends,
      events: events,
    );
  }

}

