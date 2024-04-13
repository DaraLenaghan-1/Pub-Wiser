import 'package:cloud_firestore/cloud_firestore.dart';

class Drink {
  final String name;
  final double price;
  final List<PriceSuggestion> priceSuggestions;

  Drink(
      {required this.name,
      required this.price,
      this.priceSuggestions = const []});

  factory Drink.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data()
        as Map<String, dynamic>?; // Safely cast to Map with null check
    if (data == null) {
      throw Exception("Document data is not available");
    }
    return Drink(
      name: doc.id,
      price: (data['price'] as num).toDouble(),
      priceSuggestions: data['priceSuggestions'] != null
          ? (data['priceSuggestions'] as List<dynamic>)
              .map((s) => PriceSuggestion.fromMap(s as Map<String, dynamic>,
                  doc.id)) // Assume doc.id if suitable or adjust accordingly
              .toList()
          : [],
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
    return PriceSuggestion(
      id: docId,
      userId: map['userId'],
      userEmail: map['userEmail'],
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
