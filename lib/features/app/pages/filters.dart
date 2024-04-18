import 'package:first_app/providers/filter_provider';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/models/filter_enum.dart';

class FiltersPage extends ConsumerWidget {
  const FiltersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<Filter, bool> filters = ref.watch(filterProvider);

    void handleFilterChange(Filter filter, bool isChecked) {
      ref.read(filterProvider.notifier).updateFilter(filter, isChecked);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: ListView(
        children: Filter.values.map((filter) {
          String title = filter.toString().split('.').last.replaceAll('_', ' ').capitalize();
          return SwitchListTile(
            title: Text(title),
            subtitle: Text('Only show pubs with $title'),
            value: filters[filter] ?? false,
            onChanged: (bool value) {
              handleFilterChange(filter, value);
            },
          );
        }).toList(),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
