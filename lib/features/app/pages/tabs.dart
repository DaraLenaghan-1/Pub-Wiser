import 'package:flutter/material.dart';
import 'package:first_app/models/filter_enum.dart';
import 'package:first_app/providers/filter_provider';
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

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  void _togglePubsFavourite(Pub pub) {
    setState(() {
      if (_favouritePubs.contains(pub)) {
        _favouritePubs.remove(pub);
        _showInfoMessage('Removed from favourites');
      } else {
        _favouritePubs.add(pub);
        _showInfoMessage('Added to favourites');
      }
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setFilters() async {
    final newFilters = await Navigator.of(context).push<Map<Filter, bool>>(
      MaterialPageRoute(
        builder: (context) =>
            FiltersPage(currentFilters: ref.watch(filterProvider)),
      ),
    );

    if (newFilters != null) {
      ref.read(filterProvider.notifier).state = newFilters;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFilters = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageIndex == 1
            ? 'Categories'
            : _selectedPageIndex == 2
                ? 'Your Favourites'
                : 'Home'),
        actions: [
          if (_selectedPageIndex == 1)
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: _setFilters,
            ),
        ],
      ),
      drawer:
          MainDrawer(onSelectPage: (page) {}, currentFilters: currentFilters),
      body: _buildActivePage(currentFilters),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_bar), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }

  Widget _buildActivePage(Map<Filter, bool> filters) {
    switch (_selectedPageIndex) {
      case 1:
        return CategoriesScreen(
          onToggleFavourite: _togglePubsFavourite,
          availableCategories: [],
        );
      case 2:
        return PubsPage(
          pubs: _favouritePubs,
          onToggleFavourite: _togglePubsFavourite,
        );
      default:
        return const HomePage();
    }
  }
}
