import 'package:hedieatyyproject/Model/Gift.dart';

import 'Friend.dart';
import 'Event.dart';

class User {
  final String id; // Unique identifier for the user
  String name;
  final List<Friend> friends; // List of friends
  final List<Event> events; // List of events created by the user
  List<Gift>? pledgedGifts = [];

  User({
    required this.id,
    required this.name,
    required this.friends,
    required this.events, // Initialize the events list
  });

}
