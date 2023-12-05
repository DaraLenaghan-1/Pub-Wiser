import 'package:first_app/features/app/pages/pubs_page.dart';
import 'package:first_app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:first_app/data/pub_data.dart';
import 'package:first_app/features/app/widgets/category_grid_item.dart';
import 'package:first_app/models/pub.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  void _selectCategory(BuildContext context, Category category) {
    final filteredPubs =
        pubData.where((pub) => pub.categories.contains(category.id)).toList();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => PubsPage(
            title: category.title,
            pubs: filteredPubs))); //Navigator.push(context, route)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
          backgroundColor: Colors.blue,
        ),
        body: GridView(
          padding: const EdgeInsets.all(24.0),
          //GridView.builder() is used when you have a large number of items to render.
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          children: [
            // availableCategories.map((category) => CategoryGridItem(category: category)).toList(),
            for (final category in availableCategories)
              CategoryGridItem(
                  category: category,
                  onSelectCategory: () {
                    _selectCategory(context, category);
                  })
          ],
        ));
  }
}
