import 'package:cloud_firestore/cloud_firestore.dart'
    as fs; // Alias Firestore with 'fs'
import 'package:first_app/models/category.dart';
import 'package:first_app/models/pub.dart';
import 'package:first_app/models/filter_enum.dart';

class FirestoreService {
  final fs.FirebaseFirestore _firestore = fs.FirebaseFirestore.instance;

  // Fetch categories from Firestore
  Future<List<Category>> getCategories() async {
    fs.QuerySnapshot snapshot =
        await _firestore.collection('availableCategories').get();
    return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
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
}
