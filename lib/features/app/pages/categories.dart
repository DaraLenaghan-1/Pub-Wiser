import 'package:flutter/material.dart';
import 'package:first_app/services/firestore_service.dart';
import 'package:first_app/features/app/widgets/category_grid_item.dart';
import 'package:first_app/models/category.dart';
import 'package:first_app/features/app/pages/pubs_page.dart';
import 'package:first_app/models/pub.dart';
import 'package:first_app/models/filter_enum.dart';
//import 'package:first_app/features/app/pages/filters.dart' as app_filters;

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {Key? key,
      required this.onToggleFavourite,
      required this.availableCategories,
      required List<Pub> pubs})
      : super(key: key);

  final void Function(Pub pub) onToggleFavourite;
  final List<Pub> availableCategories;

  @override
  Widget build(BuildContext context) {
    final Map<Filter, bool> currentFilters =
        ModalRoute.of(context)?.settings.arguments as Map<Filter, bool> ?? {};

    return FutureBuilder<List<Category>>(
      future: FirestoreService().getCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          return GridView.builder(
            padding: const EdgeInsets.all(24.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Category category = snapshot.data![index];
              return CategoryGridItem(
                  category: category,
                  onSelectCategory: () async {
                    // Fetch pubs for the selected category with the current filters
                    List<Pub> filteredPubs = await FirestoreService().getPubs(
                      category.id,
                      filters: currentFilters,
                    );

                    // Navigate to the PubsPage with the fetched pubs and category title
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PubsPage(
                          title: category.title,
                          pubs: filteredPubs,
                          onToggleFavourite: onToggleFavourite,
                          
                        ),
                      ),
                    );
                  }
                  // Implement the logic to handle category selection
                  // This might involve navigating to another screen with the selected category

                  );
            },
          );
        } else {
          return const Text('No categories found');
        }
      },
    );
  }
}
