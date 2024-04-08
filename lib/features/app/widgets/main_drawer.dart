import 'package:first_app/features/app/pages/filters.dart';
import 'package:first_app/models/filter_enum.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/global/common/toast.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectPage, required this.currentFilters});

  final void Function(String identifier) onSelectPage;
  final Map<Filter, bool> currentFilters;

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.local_drink, size: 48, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 18),
                Text(
                  'Pub Wiser',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.liquor, size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text(
              'Pubs',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () => onSelectPage('pubs'), //TODO: navigate to pubs page
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text(
              'Filters',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 24,
                  ),
            ),
            onTap: () {
              // Navigate to FiltersPage with currentFilters
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FiltersPage(currentFilters: currentFilters),
              ));
            },
          ),
          Spacer(), // Pushes the logout button to the bottom
          ListTile(
            leading: Icon(Icons.exit_to_app, size: 26, color: Theme.of(context).colorScheme.error),
            title: Text(
              'Sign Out',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 24,
                  ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
              showToast(message: "Signed out successfully");
            },
          ),
        ],
      ),
    );
  }
}
