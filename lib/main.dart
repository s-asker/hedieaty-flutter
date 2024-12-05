import 'package:flutter/material.dart';
import 'Model/User.dart';
import 'home_page.dart'; // Import HomePage file
import 'Model/Friend.dart'; // Import the Friend model
import 'Model/Event.dart';  // Import Event model for creating event data
import 'Model/Gift.dart';   // Import Gift model for gift data

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy friends list for testing
    final List<Friend> friends = [
      Friend(
        id: "1",
        name: "Alice Johnson",
        upcomingEvents: [
          Event(
            id: "1",
            name: "Birthday Party",
            date: DateTime.now(),
            giftList: [
              Gift(
                id: "1",
                name: "Smartphone",
                description: "Latest model",
                status: "available",
                category: "Electronics",
                price: 699.99,
              ),
              Gift(
                id: "2",
                name: "Laptop",
                description: "Gaming laptop",
                status: "available",
                category: "Electronics",
                price: 1199.49,
              ),
              Gift(
                id: "3",
                name: "Headphones",
                description: "Noise-cancelling",
                status: "pledged",
                category: "Accessories",
                price: 199.99,
              ),
            ],
          ),
        ],
      ),
      Friend(
        id: "2",
        name: "Bob Smith",
        upcomingEvents: [],
      ),
      Friend(
        id: "3",
        name: "Jane Doe",
        upcomingEvents: [
          Event(
            id: "2",
            name: "Wedding",
            date: DateTime.now().add(Duration(days: 7)),
            giftList: [
              Gift(
                id: "4",
                name: "Wedding Cake",
                description: "Delicious chocolate cake",
                status: "available",
                category: "Food",
                price: 150.0,
              ),
              Gift(
                id: "5",
                name: "Candle Set",
                description: "Aromatic candles for the couple",
                status: "available",
                category: "Home Decor",
                price: 49.99,
              ),
            ],
          ),
        ],
      ),
    ];

    User user = User(
      id: "123",
      name: "John Doe",
      friends: friends,
      events: [
        Event(
          id: "2",
          name: "Wedding",
          date: DateTime.now().add(Duration(days: 7)),
          giftList: [
            Gift(
              id: "4",
              name: "Wedding Cake",
              description: "Delicious chocolate cake",
              status: "available",
              category: "Food",
              price: 150.0,
            ),
            Gift(
              id: "5",
              name: "Candle Set",
              description: "Aromatic candles for the couple",
              status: "available",
              category: "Home Decor",
              price: 49.99,
            ),
          ],
        ),
      ],
    );

    return MaterialApp(
      title: 'Hedieaty',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(friends: friends, user: user), // Launch the HomePage directly
    );
  }
}