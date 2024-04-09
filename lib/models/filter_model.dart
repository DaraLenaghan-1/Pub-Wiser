import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/models/filter_enum.dart';

class FilterModel extends StateNotifier<Map<Filter, bool>> {
  FilterModel()
      : super({
          Filter.beerGarden: false,
          Filter.draughtIPA: false,
          Filter.sportsBar: false,
          Filter.traidBar: false,
        });

  // Update the value of a single filter
  void updateFilter(Filter filter, bool value) {
    state = {
      ...state,
      filter: value,
    };
  }

  // Set all filters at once
  void setFilters(Map<Filter, bool> newFilters) {
    state = newFilters;
  }
}
