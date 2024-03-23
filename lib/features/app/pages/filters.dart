import 'package:flutter/material.dart';
import 'package:first_app/models/filter_enum.dart';

class FiltersPage extends StatefulWidget {
  final Map<Filter, bool> currentFilters;

  const FiltersPage({Key? key, required this.currentFilters}) : super(key: key);

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late Map<Filter, bool> _selectedFilters;

  @override
  void initState() {
    super.initState();
    _selectedFilters = Map.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => Navigator.of(context).pop(_selectedFilters),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSwitchListTile(
            filter: Filter.beerGarden,
            title: 'Beer Gardens',
            subtitle: 'Only show pubs with beer gardens',
          ),
          _buildSwitchListTile(
            filter: Filter.draughtIPA,
            title: 'Draught IPA',
            subtitle: 'Only show pubs with draught IPA',
          ),
          _buildSwitchListTile(
            filter: Filter.sportsBar,
            title: 'Sports Bars',
            subtitle: 'Only show pubs with sports bars',
          ),
          _buildSwitchListTile(
            filter: Filter.traidBar,
            title: 'Traid Bars',
            subtitle: 'Only show pubs that are traid bars',
          ),
          // Add more filters as needed
        ],
      ),
    );
  }

  Widget _buildSwitchListTile({
    required Filter filter,
    required String title,
    required String subtitle,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: _selectedFilters[filter] ?? false,
      onChanged: (bool value) {
        setState(() {
          _selectedFilters[filter] = value;
        });
      },
    );
  }
}
