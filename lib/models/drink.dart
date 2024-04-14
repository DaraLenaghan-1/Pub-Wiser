import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Drink {
  final String name;
  final double price;

  Drink({
    required this.name,
    required this.price,
  });

  factory Drink.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data()
        as Map<String, dynamic>?; // Safely cast to Map with null check
    if (data == null) {
      throw Exception("Document data is not available");
    }
    return Drink(
      name: doc.id,
      price: (data['price'] as num).toDouble(),
    );
  }
}

// Define a PriceSuggestion class to handle the structure of each price suggestion
class PriceSuggestion {
  String id;
  final String userId;
  final String userEmail;
  final double suggestedPrice;
  final Timestamp timestamp;
  int votes;

  PriceSuggestion({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.suggestedPrice,
    required this.timestamp,
    this.votes = 0,
  });

  factory PriceSuggestion.fromMap(Map<String, dynamic> map, String docId) {
    if (map['userId'] == null ||
        map['suggestedPrice'] == null ||
        map['timestamp'] == null) {
      throw FlutterError(
          'Required fields are missing for a PriceSuggestion instance');
    }

    // Provide a default value for userEmail if not present
    String userEmail = map['userEmail'] ?? 'unknown@example.com';

    return PriceSuggestion(
      id: docId,
      userId: map['userId'],
      userEmail: userEmail,
      suggestedPrice: (map['suggestedPrice'] as num).toDouble(),
      timestamp: map['timestamp'],
      votes: map['votes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'suggestedPrice': suggestedPrice,
      'timestamp': timestamp,
      'votes': votes,
    };
  }

  // Function to increment vote count
  void upvote() {
    votes++;
  }

  void downvote() {
    votes--;
  }
}
