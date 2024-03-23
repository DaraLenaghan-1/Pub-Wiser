// filter_enum.dart
enum Filter {
  beerGarden,
  draughtIPA,
  sportsBar,
  traidBar,
  // Add more filters
}

// Utility function to map Filter enum values to Firestore field names
String toFirestoreFieldName(Filter filter) {
  switch (filter) {
    case Filter.beerGarden:
      return 'isBeerGarden';
    case Filter.draughtIPA:
      return 'isDraughtIPA';
    case Filter.sportsBar:
      return 'isSportsBar';
    case Filter.traidBar:
      return 'isTraidBar';
    // Add more cases
    default:
      throw Exception('Unknown Filter: $filter');
  }
}
