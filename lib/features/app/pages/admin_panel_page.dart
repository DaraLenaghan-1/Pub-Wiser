import 'package:flutter/material.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({super.key});

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to a page for managing users
              },
              child: const Text('Manage Users'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to a page for approving pub suggestions
              },
              child: const Text('Approve Pub Suggestions'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to a page for monitoring app usage
              },
              child: const Text('Monitor App Usage'),
            ),
          ],
        ),
      ),
    );
  }
}
