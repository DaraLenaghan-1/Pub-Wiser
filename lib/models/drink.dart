import 'package:cloud_firestore/cloud_firestore.dart';

class Drink {
  final String name;
  final double price;

  Drink({required this.name, required this.price});

  // Use the document ID as the drink's name and the 'price' field for its price
  factory Drink.fromFirestore(DocumentSnapshot doc) {
    return Drink(
      name: doc.id,
      price: (doc['price'] as num).toDouble(), // Cast the price to a double
    );
  }
}
