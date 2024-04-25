import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:first_app/models/filter_enum.dart';
import 'package:first_app/models/filter_model.dart';

final filterProvider = StateNotifierProvider<FilterModel, Map<Filter, bool>>((ref) {
  return FilterModel();
});
