import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/features/app/pages/filters.dart';
import 'package:first_app/features/app/pages/categories.dart';
import 'package:first_app/features/app/pages/pubs_page.dart';
import 'package:first_app/features/app/widgets/main_drawer.dart';
import 'package:first_app/features/app/pages/home_page.dart';
import 'package:first_app/models/pub.dart';

class TabsPage extends ConsumerStatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends ConsumerState<TabsPage> {
  int _selectedPageIndex = 0;
  final List<Pub> _favouritePubs = [];

  void _togglePubsFavourite(Pub pub) {
    setState(() {
      if (_favouritePubs.contains(pub)) {
        _favouritePubs.remove(pub);
      } else {
        _favouritePubs.add(pub);
      }
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setFilters() async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const FiltersPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(['Home', 'Categories', 'Your Favourites'][_selectedPageIndex]),
        actions: _selectedPageIndex == 1 ? [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _setFilters,
          ),
        ] : null,
      ),
      drawer: const MainDrawer(),
      body: _buildActivePage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.local_bar), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }

  Widget _buildActivePage() {
    switch (_selectedPageIndex) {
      case 1:
        return CategoriesScreen(
          onToggleFavourite: _togglePubsFavourite,
          availableCategories: _favouritePubs, // Pass the favourite pubs or correct available categories list
        );
      case 2:
        return PubsPage(pubs: _favouritePubs, onToggleFavourite: _togglePubsFavourite);
      default:
        return const HomePage();
    }
  }
}
