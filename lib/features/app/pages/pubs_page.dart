import 'package:first_app/features/app/widgets/pub_item.dart';
import 'package:first_app/models/pub.dart';
import 'package:flutter/material.dart';
import 'package:first_app/features/app/pages/pub_details.dart';


class PubsPage extends StatelessWidget {
  const PubsPage({super.key, required this.title, required this.pubs});

  final String title;
  final List<Pub> pubs;

  void selectPub(BuildContext context, Pub pub) {
    // Navigate to the PubDetailsPage with the selected pub
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PubDetailsPage(pub: pub),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'No pubs found',
          style: Theme.of(context)
              .textTheme
              .headlineLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          'Try selecting a different category',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ],
    ));

    if (pubs.isNotEmpty) {
      content = ListView.builder(
        itemCount: pubs.length,
        itemBuilder: (ctx, index) => PubItem(pub: pubs[index], onSelectPub: (pub){
          selectPub(context, pub);
        },),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue,
      ),
      body: content,
    );
  }
}

      /*ListView.builder(
          //itemCount: pubs.length,
          itemBuilder: (ctx, index) => Text(
                pubs[index].title,
                //style: Theme.of(context).textTheme.titleLarge,
              )
          /*{
          return ListTile(
            title: Text(pubs[index].title),
            subtitle: Text(pubs[index].categories.join(', ')),
            leading: Image.network(pubs[index].imageUrl),
          );
        },*/
          ),
    );
  }
}*/
