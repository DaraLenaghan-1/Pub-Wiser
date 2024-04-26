import 'package:first_app/providers/filter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/services/firestore_service.dart';
import 'package:first_app/features/app/widgets/category_grid_item.dart';
import 'package:first_app/models/category.dart';
import 'package:first_app/features/app/pages/pubs_page.dart';
import 'package:first_app/models/pub.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({
    super.key,
    required this.onToggleFavourite,
    required this.availableCategories,
  });

  final void Function(Pub pub) onToggleFavourite;
  final List<Pub> availableCategories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilters = ref.watch(filterProvider);

    return FutureBuilder<List<Category>>(
      future: FirestoreService().getCategoriesFiltered(currentFilters),
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
                  List<Pub> filteredPubs = await FirestoreService().getPubs(
                    category.id,
                    filters: currentFilters,
                  );

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
                },
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
