import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/category.dart';
import 'package:first_app/models/pub.dart';

class FirestoreService {
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

  Future<List<Pub>> getPubs(String categoryId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('pubs')
        .where('categories', arrayContains: categoryId)
        .get();

    // Debugging: Print the number of pubs fetched
    print(
        'Number of pubs fetched for category $categoryId: ${snapshot.docs.length}');

    return snapshot.docs.map((doc) => Pub.fromFirestore(doc)).toList();
  }
}
