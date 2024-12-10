import 'package:flutter/material.dart';
import 'sqlite/database_helper.dart';
import 'Model/Event.dart';

class EventListPage extends StatelessWidget {
  final String userId;

  const EventListPage({Key? key, required this.userId}) : super(key: key);

  Future<List<Event>> _fetchEvents() async {
    final dbHelper = DatabaseHelper();
    final eventsData = await dbHelper.fetchEvents(userId);
    return eventsData.map((event) => Event.fromMap(event)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Events")),
      body: FutureBuilder<List<Event>>(
        future: _fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No events found."));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                title: Text(event.name),
                subtitle: Text(event.description ?? "No description provided"),
                trailing: Text(event.date as String),
              );
            },
          );
        },
      ),
    );
  }
}
