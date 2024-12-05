import 'package:flutter/material.dart';
import 'Model/User.dart';

class PledgedGiftsPage extends StatelessWidget {
  final User user;

  PledgedGiftsPage({required this.user}) ;

  @override
  Widget build(BuildContext context) {
    // Ensure we fetch the pledged gifts correctly
    final pledgedGifts = user.pledgedGifts ?? [];
    debugPrint("Pledged gifts in build method: ${pledgedGifts.map((gift) => gift.name).toList()}");

    return Scaffold(
      appBar: AppBar(title: const Text("My Pledged Gifts")),
      body: pledgedGifts.isEmpty
          ? Center(
        child: const Text(
          "You haven't pledged any gifts yet.",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: pledgedGifts.length,
        itemBuilder: (context, index) {
          final gift = pledgedGifts[index];
          debugPrint("Displaying gift: ${gift.name} with status: ${gift.status}");
          return ListTile(
            title: Text(gift.name),
            subtitle: Text("Status: ${gift.status}"),
          );
        },
      ),
    );
  }
}
