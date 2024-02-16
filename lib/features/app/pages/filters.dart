//import 'package:first_app/features/app/pages/tabs.dart';
//import 'package:first_app/features/app/widgets/main_drawer.dart';
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
  var _draughtIPA = false; // _draughtIPAFilterSet
  var _sportsBar = false; // _sportsBarFilterSet
  var _traidBar = false; // _traidBarFilterSet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
      ),
      // drawer: MainDrawer(onSelectPage: (identifier) {
      //   if (identifier == 'pubs') {
      //     Navigator.of(context).push( // pushReplacement
      //       MaterialPageRoute(
      //         builder: (ctx) => const TabsPage(),
      //       ),
      //     );
      //   }
      // }),
      body: Column(children: [
        SwitchListTile(
          value: _beerGarden,
          onChanged: (isChecked) {
            setState(() {
              _beerGarden = isChecked;
            });
          },
          title: Text('Beer Gardens', // Beer Garden
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
        SwitchListTile(
          value: _draughtIPA,
          onChanged: (isChecked) {
            setState(() {
              _draughtIPA = isChecked;
            });
          },
          title: Text('IPA', // IPA
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
          subtitle: Text(
            'Only show pubs with draught IPA',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          activeColor: Theme.of(context).colorScheme.tertiary,
          contentPadding: const EdgeInsets.only(left: 34, right: 22),
        ),
        SwitchListTile(
          value: _sportsBar,
          onChanged: (isChecked) {
            setState(() {
              _sportsBar = isChecked;
            });
          },
          title: Text('Sports Bars', // sports bar
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
          subtitle: Text(
            'Only show pubs with sports on display',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          activeColor: Theme.of(context).colorScheme.tertiary,
          contentPadding: const EdgeInsets.only(left: 34, right: 22),
        ),
        SwitchListTile(
          value: _traidBar,
          onChanged: (isChecked) {
            setState(() {
              _traidBar = isChecked;
            });
          },
          title: Text('Traid Bars', // IPA
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  )),
          subtitle: Text(
            'Only show pubs with draught IPA',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          activeColor: Theme.of(context).colorScheme.tertiary,
          contentPadding: const EdgeInsets.only(left: 34, right: 22),
        ),
      ]),
    );
  }
}
