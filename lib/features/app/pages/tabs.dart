import 'package:flutter/material.dart';
import 'package:first_app/features/app/pages/filters.dart';
import 'package:first_app/features/app/pages/categories.dart';
import 'package:first_app/features/app/pages/pubs_page.dart';
import 'package:first_app/features/app/widgets/main_drawer.dart';
import 'package:first_app/features/app/pages/home_page.dart';
import 'package:first_app/models/pub.dart';
import 'package:first_app/services/firestore_service.dart';
import 'package:first_app/models/filter_enum.dart';


class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsPage> {
  int _selectedPageIndex = 0;
  final List<Pub> _favouritePubs = [];
  Map<Filter, bool> _selectedFilters = {
    Filter.beerGarden: false,
    Filter.draughtIPA: false,
    Filter.sportsBar: false,
    Filter.traidBar: false,
  };

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
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
        builder: (context) => FiltersPage(currentFilters: _selectedFilters),
      ),
    );

    if (newFilters != null) {
      setState(() {
        _selectedFilters = newFilters;
      });
    }
  }

  Widget _buildActivePage() {
    switch (_selectedPageIndex) {
      case 1:
        return FutureBuilder<List<Pub>>(
          future: FirestoreService().getPubs(
            "", // Pass the selected category ID here
            filters: _selectedFilters
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return CategoriesScreen(
                pubs: snapshot.data!,
                onToggleFavourite: _togglePubsFavourite, availableCategories: [],
              );
            } else {
              return Text('No pubs found');
            }
          },
        );
      case 2:
        return PubsPage(
          pubs: _favouritePubs,
          onToggleFavourite: _togglePubsFavourite,
        );
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageIndex == 1 ? 'Categories' : _selectedPageIndex == 2 ? 'Your Favourites' : 'Home'),
        actions: [
          if (_selectedPageIndex == 1)
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: _setFilters,
            ),
        ],
      ),
      drawer: MainDrawer(onSelectPage: (page) {}),
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
}
