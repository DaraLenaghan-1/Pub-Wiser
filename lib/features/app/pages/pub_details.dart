import 'package:flutter/material.dart';
import 'package:first_app/models/pub.dart';

class PubDetailsPage extends StatelessWidget {
  const PubDetailsPage ({super.key, required this.pub});

  final Pub pub;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pub.title),
      ),
      body: Image.network(
        pub.imageUrl,
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),    
    );
  }
}