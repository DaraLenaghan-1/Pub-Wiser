import 'package:first_app/data/firebase_store_implementation/firestore_pubData.dart';
import 'package:first_app/features/app/pages/categories.dart';
import 'package:first_app/features/app/pages/filters.dart';
import 'package:first_app/features/app/pages/pubs_page.dart';
import 'package:first_app/features/app/widgets/main_drawer.dart';
import 'package:first_app/features/user_auth/UI/pages/home_page.dart';
import 'package:first_app/models/pub.dart';
import 'package:flutter/material.dart';

const kInitialFilters = {
  // k at the beginning of the global variable name is a Flutter convention to indicate that the variable is a constant // not required
  Filter.beerGarden: false,
  Filter.draughtIPA: false,
  Filter.sportsBar: false,
  Filter.traidBar: false,
};

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsPage> {
  int _selectedPageIndex = 0; // 0 for home 1 for categories, 2 for favourites
  final List<Pub> _favouritePubs = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Define a function to toggle a pub in the favourite pubs list
  void _togglePubsFavourite(Pub pub) {
    final isExisting = _favouritePubs
        .contains(pub); //Check if the pub is already in the favourite pubs list
    if (isExisting) {
      setState(() {
        // If the pub is in the list, remove it from the list
        _favouritePubs.remove(pub);
      });
      _showInfoMessage('Removed from favourites');
    } else {
      setState(() {
        // If the pub is not in the list, add it to the list
        _favouritePubs.add(pub);
        _showInfoMessage('Added to favourites');
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setPage(String identifier) async {
    Navigator.of(context).pop(); // Close the drawer
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        //pushReplacement - replaces the current page instead of pushing a new page
        MaterialPageRoute(
          builder: (ctx) => FiltersPage(currentFilters: _selectedFilters),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
      print(result); // log the result from the filters page
    } else {
      Navigator.of(context).pop(); // Close the drawer
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableCategories = FirestorePubData.where((pub) {
      if (_selectedFilters[Filter.beerGarden]! && !pub.isBeerGarden) {
        return false;
      }
      if (_selectedFilters[Filter.draughtIPA]! && !pub.isDraughtIPA) {
        return false;
      }
      if (_selectedFilters[Filter.sportsBar]! && !pub.isSportsBar) {
        return false;
      }
      if (_selectedFilters[Filter.traidBar]! && !pub.isTraidBar) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = const HomePage();
    var activePageTitle = 'Home';

    if (_selectedPageIndex == 1) {
      activePage = CategoriesScreen(
          onToggleFavourite: _togglePubsFavourite,
          availableCategories: availableCategories);
      activePageTitle = 'Categories';
    } else if (_selectedPageIndex == 2) {
      activePage = PubsPage(
        pubs: _favouritePubs,
        onToggleFavourite: _togglePubsFavourite,
      );
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectPage: _setPage,
      ),
      body: activePage,
      // Define the bottom navigation bar with the tabs,
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
}
