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
                  print(
                      "Snapshot error: ${snapshot.error}"); // Logging the error
                  return Center(
                      child: Text(
                          "Error: ${snapshot.error.toString()}")); // Displaying error message
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  print(
                      "Data fetched, but no items found."); // Log empty data situation
                  return Center(
                      child: Text(
                          "No drinks found")); // Informing user there are no drinks
                } else if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.map((drink) {
                      return ListTile(
                        title: Text(drink.name),
                        trailing: Text('€${drink.price.toStringAsFixed(2)}'),
                        onTap: () => _showUpdatePriceDialog(context, drink),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.list),
                              onPressed: () =>
                                  _showPriceSuggestions(context, drink.name),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Text(
                      'Unable to load drinks'); // Handling unexpected no data scenario
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
      String docId =
          "${currentUser.uid}_${Timestamp.now().millisecondsSinceEpoch}";
      String username = currentUser.displayName ??
          "Unknown User"; // Use username instead of email for privacy

      var newSuggestion = {
        "userId": currentUser.uid,
        "username": username, // Store username instead of userEmail
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
          .doc(docId)
          .set(newSuggestion);

      showToast(message: "Price suggestion added successfully!");
    } else {
      showToast(message: "No user logged in!");
    }
  }

  void _showPriceSuggestions(BuildContext context, String drinkId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<List<PriceSuggestion>>(
            future:
                FirestoreService().getPriceSuggestions(widget.pub.id, drinkId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || snapshot.data == null) {
                print("Error fetching data: ${snapshot.error}");
                return Center(
                    child:
                        Text("Failed to load suggestions, please try again."));
              }
              var suggestions = snapshot.data!;
              if (suggestions.isEmpty) {
                return Center(child: Text("No price suggestions available."));
              }
              return ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  var suggestion = suggestions[index];
                  return ListTile(
                    title: Text(
                        '€${suggestion.suggestedPrice.toStringAsFixed(2)} by ${suggestion.userEmail}'),
                    subtitle: Text('Votes: ${suggestion.votes}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () => voteOnSuggestion(
                              widget.pub.id, drinkId, suggestion.id, true),
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () => voteOnSuggestion(
                              widget.pub.id, drinkId, suggestion.id, false),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void voteOnSuggestion(
      String pubId, String drinkId, String suggestionId, bool upvote) {
    FirebaseFirestore.instance
        .collection('pubData')
        .doc(pubId)
        .collection('drinkPrices')
        .doc(drinkId)
        .collection('PriceSuggestions')
        .doc(suggestionId)
        .update({'votes': FieldValue.increment(upvote ? 1 : -1)}).then((_) {
      showToast(message: "Vote updated successfully!");
      Navigator.pop(context); // This line closes the modal before reopening
      _showPriceSuggestions(
          context, drinkId); // Reopen the modal with updated data
    }).catchError((error) {
      showToast(message: "Error updating vote: $error");
      print(error);
    });
  }

  Future<PriceSuggestion?> getTopPriceSuggestion(
      String pubId, String drinkName) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('pubData')
          .doc(pubId)
          .collection('drinkPrices')
          .doc(drinkName)
          .collection('PriceSuggestions')
          .orderBy('votes', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return PriceSuggestion.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      print("Error fetching top price suggestion: $e");
      return null;
    }
  }

  void updateDrinkWithTopSuggestion(String pubId, String drinkName) async {
    final topSuggestion = await getTopPriceSuggestion(pubId, drinkName);
    if (topSuggestion != null) {
      await FirebaseFirestore.instance
          .collection('pubData')
          .doc(pubId)
          .collection('drinkPrices')
          .doc(drinkName)
          .update({'price': topSuggestion.suggestedPrice}).then((_) {
        // Trigger a UI update to reflect the new price
        setState(() {
          _drinksFuture = FirestoreService().getDrinkPrices(widget.pub.id);
        });
        showToast(message: "Price updated to top suggestion.");
      }).catchError((error) {
        showToast(message: "Error updating price: $error");
        print(error);
      });
    }
  }
}
