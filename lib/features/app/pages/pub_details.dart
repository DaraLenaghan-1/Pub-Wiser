import 'package:flutter/material.dart';
import 'package:first_app/models/pub.dart';

class PubDetailsPage extends StatelessWidget {
  const PubDetailsPage(
      {super.key, required this.pub, required this.onToggleFavourite});

  final Pub pub;
  final void Function(Pub pub) onToggleFavourite;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(pub.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                onToggleFavourite(pub); // Call the onToggleFavourite function
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            // ListView
            children: [
              Image.network(
                pub.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 14),
              Text(
                pub.description,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      /*const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,*/
                    ),
              ),
              const SizedBox(height: 14),
              // TODO - pub details = icon + label
            ],
          ),
        ));
  }
}
