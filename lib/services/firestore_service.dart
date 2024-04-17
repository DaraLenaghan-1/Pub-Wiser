import 'package:cloud_firestore/cloud_firestore.dart'
    as fs; // Alias Firestore with 'fs'
import 'package:first_app/models/category.dart';
import 'package:first_app/models/drink.dart';
import 'package:first_app/models/pub.dart';
import 'package:first_app/models/filter_enum.dart';

class FirestoreService {
  final fs.FirebaseFirestore _firestore = fs.FirebaseFirestore.instance;

  // Fetch categories from Firestore, now applying filters.
  Future<List<Category>> getCategoriesFiltered(
      Map<Filter, bool> filters) async {
    try {
      fs.Query query = _firestore.collection('availableCategories');

      // Apply filters dynamically based on the current filters
      filters.forEach((filter, value) {
        if (value) {
          String fieldName = toFirestoreFieldName(filter);
          query = query.where(fieldName, isEqualTo: true);
        }
      });

      fs.QuerySnapshot snapshot = await query.get();
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching categories with filters: $e');
      return []; // Return an empty list on error or consider rethrowing
    }
  }

  // Fetch pubs with a category filter and additional boolean filters
  Future<List<Pub>> getPubs(String categoryId,
      {Map<Filter, bool>? filters}) async {
    try {
      fs.Query query = _firestore.collection('pubData');
      if (categoryId.isNotEmpty) {
        query = query.where('categories', arrayContains: categoryId);
      }

      filters?.forEach((filter, value) {
        if (value) {
          String fieldName = toFirestoreFieldName(filter);
          query = query.where(fieldName, isEqualTo: value);
        }
      });

      fs.QuerySnapshot snapshot = await query.get();
      print(
          'Number of pubs fetched for category $categoryId with filters: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) => Pub.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching pubs: $e');
      return []; // Return an empty list on error or consider rethrowing
    }
  }

  Future<List<Drink>> getDrinkPrices(String pubId) async {
    try {
      fs.QuerySnapshot snapshot = await fs.FirebaseFirestore.instance
          .collection('pubData')
          .doc(pubId)
          .collection('drinkPrices')
          .get();

      // Use the document ID as the drink's name and the 'price' field for its price
      return snapshot.docs.map((doc) => Drink.fromFirestore(doc)).toList();
    } catch (e) {
      if (e is fs.FirebaseException && e.code == 'permission-denied') {
        print('Lack of permissions for accessing drink prices.');
      } else {
        print('Error fetching drinks: $e');
      }
      return []; // Return an empty list to signify an error non-intrusively
    }
  }

  Future<void> updateDrinkPrice(
      String drinkName, double newPrice, String pubId) async {
    await fs.FirebaseFirestore.instance
        .collection('pubData')
        .doc(pubId)
        .collection('drinkPrices')
        .doc(drinkName)
        .update({'price': newPrice});
  }

  Future<List<PriceSuggestion>> getPriceSuggestions(
      String pubId, String drinkName) async {
    try {
      var snapshot = await _firestore
          .collection('pubData')
          .doc(pubId)
          .collection('drinkPrices')
          .doc(drinkName)
          .collection('PriceSuggestions')
          .orderBy('timestamp', descending: true) // Order by timestamp
          .get();

      return snapshot.docs
          .map((doc) => PriceSuggestion.fromMap(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error fetching price suggestions: $e");
      return [];
    }
  }

  // Method to get the top price suggestion based on votes
  Future<PriceSuggestion?> getTopPriceSuggestion(
      String pubId, String drinkName) async {
    try {
      var snapshot = await _firestore
          .collection('pubData')
          .doc(pubId)
          .collection('drinkPrices')
          .doc(drinkName)
          .collection('PriceSuggestions')
          .orderBy('votes', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();
        return PriceSuggestion.fromMap(data, snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      print("Error fetching top price suggestion: $e");
      return null;
    }
  }

  // Method to update the drink's price with the top voted price suggestion
  Future<void> updateDrinkPriceWithTopSuggestion(
      String pubId, String drinkName) async {
    var topSuggestion = await getTopPriceSuggestion(pubId, drinkName);
    if (topSuggestion != null && topSuggestion.votes > 0) {
      return updateDrinkPrice(drinkName, topSuggestion.suggestedPrice, pubId);
    }
  }
}
