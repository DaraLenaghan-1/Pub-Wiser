import 'package:flutter/material.dart';
import 'package:first_app/models/pub.dart';
import 'package:first_app/models/drink.dart';
import 'package:first_app/services/firestore_service.dart';

class PubDetailsPage extends StatefulWidget {
  const PubDetailsPage({
    super.key,
    required this.pub,
    required this.onToggleFavourite,
  });

  final Pub pub;
  final void Function(Pub pub) onToggleFavourite;

  @override
  _PubDetailsPageState createState() => _PubDetailsPageState();
}

class _PubDetailsPageState extends State<PubDetailsPage> {
  late Future<List<Drink>> _drinksFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the drinksFuture with a method that fetches drink data for the current pub
    _drinksFuture = FirestoreService().getDrinkPrices(widget.pub.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pub.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => widget.onToggleFavourite(widget.pub),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              widget.pub.imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 14),
            Text(
              widget.pub.description,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 14),
            FutureBuilder<List<Drink>>(
              future: _drinksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  // Build the list of drink widgets
                  return Column(
                    children: snapshot.data!
                        .map((drink) => ListTile(
                              title: Text(drink.name),
                              trailing:
                                  Text('${drink.price.toStringAsFixed(2)}'),
                            ))
                        .toList(),
                  );
                } else {
                  return const Text('No drinks found');
                }
              },
            ),
            // Add more pub details as needed
          ],
        ),
      ),
    );
  }
}
