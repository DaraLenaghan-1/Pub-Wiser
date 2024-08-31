import 'dart:convert';
import 'package:first_app/models/drink.dart';
import 'package:first_app/services/firestore_service.dart';
import 'package:http/http.dart' as http;
import 'package:first_app/const.dart';

class GooglePlacesClient {
  final http.Client httpClient = http.Client();

  Future<List<Place>> fetchBars(double latitude, double longitude) async {
    const int radius = 1500; // Radius in meters
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String url =
        '$baseUrl?location=$latitude,$longitude&radius=$radius&type=bar&keyword=pub&key=$GOOGLE_MAPS_API_KEY';

    var response = await httpClient.get(Uri.parse(url));
    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("API Response: $data");
      if (data['status'] == 'OK') {
        return (data['results'] as List)
            .map((result) => Place.fromMap(result))
            .toList();
      } else {
        throw Exception('Failed to load bars: ${data['error_message']}');
      }
    } else {
      throw Exception(
          'Failed to make API call with status: ${response.statusCode}');
    }
  }

// Method to get the photo URL from a photo reference
  Future<Place> fetchPlaceDetails(String placeId) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=name,rating,formatted_phone_number,formatted_address,reviews,photos&key=$GOOGLE_MAPS_API_KEY';
    try {
      var response = await httpClient.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == 'OK') {
          Place place = Place.fromDetailMap(data['result']);
          // Fetch additional data from Firestore and update the place
          List<Drink> drinks = await FirestoreService().getDrinkPrices(placeId);
          place.updateDrinks(drinks);
          return place; // Return the updated place
        } else {
          throw Exception(
              'Failed to load place details: ${data['error_message']}');
        }
      } else {
        throw Exception('HTTP error with status: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching place details: $e");
      rethrow;
    }
  }
}

class Place {
  final String name;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final String? description;
  final String placeId;
  String? address;
  String? phoneNumber;
  double? rating;
  List<String>? reviews;
  List<String>? photoReferences;
  String? openingHours;
  List<Drink> drinks = [];

  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.description,
    required this.placeId,
    this.address,
    this.phoneNumber,
    this.rating,
    this.reviews,
    this.photoReferences,
    this.openingHours,
  });

  // Method to update the place details after fetching from the API
  void updateDetails(String address, String phoneNumber, double rating,
      List<String> reviews, List<String> photoReferences) {
    this.address = address;
    this.phoneNumber = phoneNumber;
    this.rating = rating;
    this.reviews = reviews;
    this.photoReferences = photoReferences;
  }

  // New method to update drinks
  void updateDrinks(List<Drink> newDrinks) {
    drinks = newDrinks;
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    List<String>? photoRefs = (map['photos'] as List?)
        ?.map((photo) => photo['photo_reference'].toString())
        .toList();
    return Place(
      name: map['name'],
      latitude: map['geometry']['location']['lat'],
      longitude: map['geometry']['location']['lng'],
      placeId: map['place_id'],
      photoReferences: photoRefs,
    );
  }

  factory Place.fromDetailMap(Map<String, dynamic> map) {
    var geometry = map['geometry'] as Map<String, dynamic>?;
    var location = geometry?['location'] as Map<String, dynamic>?;
    double lat = (location?['lat'] as double?) ?? 0.0;
    double lng = (location?['lng'] as double?) ?? 0.0;

    String address =
        (map['formatted_address'] as String?) ?? 'No address available';
    String phoneNumber = (map['formatted_phone_number'] as String?) ??
        'No phone number available';
    double rating = (map['rating'] as num?)?.toDouble() ?? 0.0;

    var reviewsData = map['reviews'] as List<dynamic>? ?? [];
    List<String> reviews = reviewsData
        .map((r) => (r['text'] as String?) ?? 'No review text')
        .toList();

    var photosData = map['photos'] as List<dynamic>? ?? [];
    List<String> photoReferences =
        photosData.map((p) => (p['photo_reference'] as String?) ?? '').toList();

    String openingHours =
        (map['opening_hours']?['weekday_text'] as List<dynamic>?)?.join('\n') ??
            'No opening hours available';

    return Place(
      name: map['name'] as String? ?? 'Unknown',
      latitude: lat,
      longitude: lng,
      placeId: map['place_id'] as String? ?? 'No Place ID',
      address: address,
      phoneNumber: phoneNumber,
      rating: rating,
      reviews: reviews,
      photoReferences: photoReferences,
      openingHours: openingHours,
    );
  }

  String getPhotoUrl(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$GOOGLE_MAPS_API_KEY';
  }
}
