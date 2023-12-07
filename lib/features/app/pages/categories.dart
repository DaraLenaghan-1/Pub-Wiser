import 'package:flutter/material.dart';
import 'package:first_app/services/firestore_service.dart';
import 'package:first_app/features/app/widgets/category_grid_item.dart';
import 'package:first_app/models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Category>>(
        future: FirestoreService().getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
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
                  onSelectCategory: () {
                    // Implement the logic to handle category selection
                    // This might involve navigating to another screen with the selected category
                  },
                );
              },
            );
          } else {
            return Text('No categories found');
          }
        },
      ),
    );
  }
}
