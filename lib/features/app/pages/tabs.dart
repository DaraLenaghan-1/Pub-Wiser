import 'package:first_app/features/app/pages/categories.dart';
import 'package:first_app/features/app/pages/pubs_page.dart';
import 'package:first_app/features/user_auth/UI/pages/home_page.dart';
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
      activePage = const CategoriesScreen();
      activePageTitle = 'Categories';
    } else
    if (_selectedPageIndex == 2) {
      activePage = const PubsPage(title: 'Favourites', pubs: []);
      activePageTitle = 'Your Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
    ),
    body: activePage,
    bottomNavigationBar: BottomNavigationBar(
      onTap: _selectPage,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.local_bar), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }
}