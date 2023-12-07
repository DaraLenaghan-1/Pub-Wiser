import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/category.dart';
import 'package:first_app/models/pub.dart';

class FirestoreService {
  Future<List<Category>> getCategories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('categories').get();
    return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
  }

  Future<List<Pub>> getPubs() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pubs').get();
    return snapshot.docs.map((doc) => Pub.fromFirestore(doc)).toList();
  }
}
