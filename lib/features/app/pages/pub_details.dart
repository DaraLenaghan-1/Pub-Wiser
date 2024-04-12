import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/global/common/toast.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/pub.dart';
import 'package:first_app/models/drink.dart';
import 'package:first_app/services/firestore_service.dart';

class PubDetailsPage extends StatefulWidget {
  const PubDetailsPage({
    Key? key,
    required this.pub,
    required this.onToggleFavourite,
  }) : super(key: key);

  final Pub pub;
  final void Function(Pub) onToggleFavourite;

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

  Future<void> _showUpdatePriceDialog(BuildContext context, Drink drink) async {
    TextEditingController _priceController =
        TextEditingController(text: drink.price.toString());

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Price for ${drink.name}'),
          content: TextField(
            controller: _priceController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'New Price',
              hintText: 'e.g. 5.75',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Update'),
              onPressed: () {
                double? newPrice = double.tryParse(_priceController.text);
                if (newPrice != null) {
                  FirestoreService()
                      .updateDrinkPrice(drink.name, newPrice, widget.pub.id)
                      .then((_) {
                    Navigator.of(context).pop();
                    setState(() {
                      _drinksFuture =
                          FirestoreService().getDrinkPrices(widget.pub.id);
                    });
                    // Now also pass drink name along with pub ID
                    createPriceSuggestion(widget.pub.id, drink.name, newPrice);
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error updating price: $error')),
                    );
                  });
                }
              },
            ),
          ],
        );
      },
    );
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
            SizedBox(height: 14),
            Text(
              widget.pub.description,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            SizedBox(height: 14),
            FutureBuilder<List<Drink>>(
              future: _drinksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.map((drink) {
                      return ListTile(
                        title: Text(drink.name),
                        trailing: Text('€${drink.price.toStringAsFixed(2)}'),
                        onTap: () => _showUpdatePriceDialog(context, drink),
                      );
                    }).toList(),
                  );
                } else {
                  return Text('No drinks found');
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void createPriceSuggestion(
      String pubId, String drinkName, double newPrice) async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Construct the document ID based on user and current timestamp
      String docId =
          "${currentUser.uid}_${Timestamp.now().millisecondsSinceEpoch}";

      var newSuggestion = {
        "userId": currentUser.uid,
        "userEmail": currentUser.email!,
        "suggestedPrice": newPrice,
        "timestamp": Timestamp.now(),
        "votes": 0,
      };

      await FirebaseFirestore.instance
          .collection('pubData')
          .doc(pubId)
          .collection('drinkPrices')
          .doc(drinkName)
          .collection('PriceSuggestions')
          .doc(docId) // Use the custom document ID
          .set(newSuggestion);

      showToast(message: "Price suggestion added successfully!");
    } else {
      showToast(message: "No user logged in!");
    }
  }
}
