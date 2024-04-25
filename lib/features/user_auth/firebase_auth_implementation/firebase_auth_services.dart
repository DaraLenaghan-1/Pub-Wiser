import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/global/common/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      // Create user with email and password
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      // Check if the user is not null
      if (user != null) {
        // Add the user details to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'username': username,
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'user' // Default role
        });
        showToast(message: 'Sign up successful');
        return user;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The account already exists for that email.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    } catch (e) {
      showToast(message: 'Failed to sign up: $e');
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occured: ${e.code}');
      }
    }

    return null;
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return await _auth.signInWithCredential(credential);
  }
}
