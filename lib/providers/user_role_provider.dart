import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userRoleProvider = FutureProvider<String>((ref) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    // Cast the data to Map<String, dynamic> to avoid type errors
    Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

    // Check if data is not null and contains the role field
    if (data != null && data.containsKey('role')) {
      return data['role'] as String; // Safely return the role
    }
  }
  return 'user'; // Default to 'user' role if there are any issues
});
