import 'package:flutter/material.dart';
import 'package:first_app/services/firestore_service.dart';
import 'package:first_app/models/pub.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State {
// FirestoreService can be used to interact with Firestore for data manipulation
  final FirestoreService _firestoreService = FirestoreService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Example button for fetching unapproved pubs
            ElevatedButton(
              onPressed: () => _navigateToUnapprovedPubs(context),
              child: Text("Review Pubs"),
            ),
            // Example button for managing user roles
            ElevatedButton(
              onPressed: () => _navigateToUserRoles(context),
              child: Text("Manage User Roles"),
            ),
          ],
        ),
      ),
    );
  }

// Navigate to a page showing unapproved pubs
  void _navigateToUnapprovedPubs(BuildContext context) {
    //Navigator.of(context).push(MaterialPageRoute(
      //builder: (context) => UnapprovedPubsPage(),
   // ));
  }

// Navigate to a page for managing user roles
  void _navigateToUserRoles(BuildContext context) {
   // Navigator.of(context).push(MaterialPageRoute(
      //builder: (context) => UserRoleManagementPage(),
    //));
  }
}
