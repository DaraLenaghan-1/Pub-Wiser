import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePubData extends StatefulWidget {
  @override
  _FirestorePubDataState createState() => _FirestorePubDataState();
}

class _FirestorePubDataState extends State<FirestorePubData> {
  var firestoreDb =
      FirebaseFirestore.instance.collection("Pub_Data").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pub Data'),
      ),
      body: StreamBuilder(
          stream: firestoreDb,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, int index) {
                  return Text(snapshot.data!.docs[index]['description']);
                  /*return Card(
                    child: ListTile(
                      title: Text(snapshot.data!.docs[index]['name']),
                      subtitle: Text(snapshot.data!.docs[index]['description']),
                    ),
                  );*/
                });
          }),
    );
  }
}
