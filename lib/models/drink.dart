import 'package:cloud_firestore/cloud_firestore.dart';

class Drink {
  final String name;
  final double price;
  final List<PriceSuggestion> priceSuggestions; // A list to hold price suggestions

  Drink({
    required this.name,
    required this.price,
    this.priceSuggestions = const [],
  });

  // Factory method to create a Drink from Firestore document snapshot
  factory Drink.fromFirestore(DocumentSnapshot doc) {
    return Drink(
      name: doc.id,  // Use the document ID as the drink name
      price: (doc['price'] as num).toDouble(),  // Cast the price to double
      priceSuggestions: (doc['priceSuggestions'] as List<dynamic> ?? []).map((suggestion) => 
        PriceSuggestion.fromMap(suggestion)).toList(),
    );
  }
}

// Define a PriceSuggestion class to handle the structure of each price suggestion
class PriceSuggestion {
  final String userId;
  final String userEmail;
  final double suggestedPrice;
  final Timestamp timestamp;
  final int votes;

  PriceSuggestion({
    required this.userId,
    required this.userEmail,
    required this.suggestedPrice,
    required this.timestamp,
    this.votes = 0,
  });

  // Factory method to create PriceSuggestion from a Map (from Firestore)
  factory PriceSuggestion.fromMap(Map<String, dynamic> map) {
    return PriceSuggestion(
      userId: map['userId'],
      userEmail: map['userEmail'],
      suggestedPrice: (map['suggestedPrice'] as num).toDouble(),
      timestamp: map['timestamp'],
      votes: map['votes'] ?? 0,
    );
  }

  // Method to convert a PriceSuggestion to a Map, useful for uploading to Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'suggestedPrice': suggestedPrice,
      'timestamp': timestamp,
      'votes': votes,
    };
  }
}
