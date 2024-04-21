class BarDetails {
  final String title;
  final String description;
  final String imageUrl;
  final bool isAccessible;
  // Add more fields as necessary...

  BarDetails({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isAccessible,
    // Initialize more fields as necessary...
  });

  factory BarDetails.fromMap(Map<String, dynamic> data) {
    return BarDetails(
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      isAccessible: data['isAccessible'],
      // Map more fields as necessary...
    );
  }
}
