import 'package:cloud_firestore/cloud_firestore.dart';

enum Affordability {
  affordable,
  pricey,
  luxurious,
}

enum Mood {
  cosy,
  modern,
}

class Pub {
  // properties set through named parameters
  const Pub({
    required this.id,
    required this.categories,
    required this.title,
    required this.imageUrl,
    required this.affordability,
    //required this.mood,
    required this.isAccessible,
    //required this.isTwentyOnes,
    //required this.isRoofTop,
    //required this.isBeerGarden,
    //required this.isFoodServed,
    //required this.isOldFashioned,
    //required this.isCocktailBar,
    required this.isLateNight,
    //required this.isLiveMusic,
    //required this.isSportsBar,
    //required this.isStudentFriendly,
    //required this.isDanceFloor,
    //required this.isKaraoke,
    //required this.isQuiz,
    //required this.isComedy,
    //required this.isOpenMic,
    //required this.isBoardGames,
    //required this.isDarts,
    //required this.isPool,
  });

// Factory constructor to create a Pub from a Firestore document.
  factory Pub.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Pub(
      id: doc.id,
      categories: List<String>.from(data['categories']),
      title: data['title'],
      imageUrl: data['imageUrl'],
      affordability: _mapStringToAffordability(data['affordability']),
      isAccessible: data['isAccessible'] ?? false,
      isLateNight: data['isLateNight'] ?? false,
      // Map other properties similarly
    );
  }

// Helper method to convert string to Affordability enum
  static Affordability _mapStringToAffordability(String? str) {
    switch (str) {
      case 'pricey':
        return Affordability.pricey;
      case 'luxurious':
        return Affordability.luxurious;
      default:
        return Affordability.affordable;
    }
  }

  // Add similar methods for other enums if needed

  // properties
  final String id;
  final List<String> categories;
  final String title;
  final String imageUrl;
  final Affordability affordability;
  //final Mood mood;
  final bool isAccessible;
  //final bool isTwentyOnes;
  //final bool isRoofTop;
  //final bool isBeerGarden;
  //final bool isFoodServed;
  //final bool isOldFashioned;
  //final bool isCocktailBar;
  final bool isLateNight;
  //final bool isLiveMusic;
  //final bool isSportsBar;
  //final bool isStudentFriendly;
  //final bool isDanceFloor;
  //final bool isKaraoke;
  //final bool isQuiz;
  //final bool isComedy;
  //final bool isOpenMic;
  //final bool isBoardGames;
  //final bool isDarts;
  //final bool isPool;
}
