import 'package:first_app/features/app/pages/tabs.dart';
import 'package:first_app/features/app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() {
    return _FiltersPageState();
  }
}

class _FiltersPageState extends State<FiltersPage> {
  var _beerGarden = false; // _beerGardenFilterSet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      drawer: MainDrawer(onSelectPage: (identifier) {
        if (identifier == 'pubs') {
          Navigator.of(context).push( // pushReplacement
            MaterialPageRoute(
              builder: (ctx) => const TabsPage(),
            ),
          );
        }
      }),
      body: Column(children: [
        SwitchListTile(
          value: _beerGarden,
          onChanged: (isChecked) {
            setState(() {
              _beerGarden = isChecked;
            });
          },
          title: Text('Beer Garden',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
          subtitle: Text(
            'Only show pubs with beer gardens',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          activeColor: Theme.of(context)
              .colorScheme
              .tertiary, // Color of the switch when it is on
          contentPadding: const EdgeInsets.only(left: 34, right: 22),
        ),
      ]),
    );
  }
}
