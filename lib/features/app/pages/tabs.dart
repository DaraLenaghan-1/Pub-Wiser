import 'package:first_app/features/app/pages/categories.dart';
import 'package:first_app/features/app/pages/pubs_page.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsPage> {
  int _selectedPageIndex = 0; // 0 for categories, 1 for favourites

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const CategoriesScreen();
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = PubsPage(title: 'Favourites', pubs: []);
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
        BottomNavigationBarItem(icon: Icon(Icons.local_bar), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }
}