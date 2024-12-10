import 'package:flutter/material.dart';
import 'sqlite/database_helper.dart';
import 'Model/Gift.dart';

class GiftListPage extends StatelessWidget {
  final String eventId;

  const GiftListPage({Key? key, required this.eventId}) : super(key: key);

  Future<List<Gift>> _fetchGifts() async {
    final dbHelper = DatabaseHelper();
    final giftsData = await dbHelper.fetchGifts(eventId);
    return giftsData.map((gift) => Gift.fromMap(gift)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gifts for Event")),
      body: FutureBuilder<List<Gift>>(
        future: _fetchGifts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No gifts found."));
          }

          final gifts = snapshot.data!;
          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return ListTile(
                title: Text(gift.name),
                subtitle: Text(gift.description ?? "No description provided"),
                trailing: Text("\$${gift.price.toStringAsFixed(2)}"),
              );
            },
          );
        },
      ),
    );
  }
}
