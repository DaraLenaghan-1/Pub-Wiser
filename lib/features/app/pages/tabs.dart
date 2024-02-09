import 'package:first_app/features/app/pages/categories.dart';
import 'package:first_app/features/app/pages/pubs_page.dart';
import 'package:first_app/features/user_auth/UI/pages/home_page.dart';
import 'package:first_app/models/pub.dart';

import 'package:flutter/material.dart';

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
  void _toggleMealFavourite(Pub pub) {
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

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomePage();
    var activePageTitle = 'Home';

    if (_selectedPageIndex == 1) {
      activePage = CategoriesScreen(onToggleFavourite: _toggleMealFavourite);
      activePageTitle = 'Categories';
    } else if (_selectedPageIndex == 2) {
      activePage = PubsPage(
        pubs: _favouritePubs,
        onToggleFavourite: _toggleMealFavourite,
      );
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
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
