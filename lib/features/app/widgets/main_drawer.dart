import 'package:first_app/providers/filter_provider';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/features/app/pages/filters.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/global/common/toast.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilters = ref.watch(filterProvider);

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
            title: Text('Pubs', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 24)),
            onTap: () => Navigator.of(context).popAndPushNamed('/pubs'),
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 26, color: Theme.of(context).colorScheme.onBackground),
            title: Text('Filters', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 24)),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FiltersPage())),
          ),
          const Spacer(),
          ListTile(
            leading: Icon(Icons.exit_to_app, size: 26, color: Theme.of(context).colorScheme.error),
            title: Text('Sign Out', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 24)),
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
