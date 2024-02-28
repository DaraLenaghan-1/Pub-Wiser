import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/category.dart';
import 'package:first_app/models/pub.dart';
import 'package:first_app/features/app/pages/filters.dart' as app_filters;

class FirestoreService {
  FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Create an instance of Firestore

  // fetch categories from Firestore
  Future<List<Category>> getCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('availableCategories')
        .get();
    return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
  }

  /*Future<List<Pub>> getPubs() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('pubData').get();
    return snapshot.docs.map((doc) => Pub.fromFirestore(doc)).toList();
  }
}*/

  // fetch pubs with a category filter and additional boolean filters
  Future<List<Pub>> getPubs(String categoryId,
      {Map<app_filters.Filter, bool>? filters}) async {
    //QuerySnapshot snapshot = await FirebaseFirestore.instance
    Query query = _firestore
        .collection('pubData')
        .where('categories', arrayContains: categoryId);

    // Apply additional filters
    filters?.forEach((filter, value) {
      if (value) {
        // Apply the filter only if it is true
        String fieldName = _getFirestoreFieldName(filter);
        query = query.where(fieldName, isEqualTo: value);
      }
    });

    QuerySnapshot snapshot = await query.get();

    // Debugging: Print the number of pubs fetched
    print(
        'Number of pubs fetched for category $categoryId with filters: ${snapshot.docs.length}');

    return snapshot.docs.map((doc) => Pub.fromFirestore(doc)).toList();
  }

  // Helper method to convert from Filter enum to Firestore field name
  String _getFirestoreFieldName(app_filters.Filter filter) {
    switch (filter) {
        case app_filters.Filter.beerGarden:
            return 'isBeerGarden';
        case app_filters.Filter.draughtIPA:
            return 'isDraughtIPA';
        case app_filters.Filter.sportsBar:
            return 'isSportsBar';
        case app_filters.Filter.traidBar:
            return 'isTraidBar';
        // Add more cases as needed
        default:
            throw Exception('Unknown filter: $filter');
    }
  }
}
