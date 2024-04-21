import 'dart:convert';
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

    var response = await httpClient.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        return Place.fromDetailMap(data['result']);
      } else {
        throw Exception(
            'Failed to load place details: ${data['error_message']}');
      }
    } else {
      throw Exception(
          'Failed to make place details API call with status: ${response.statusCode}');
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
    // Safely get the nested location data to avoid 'NoSuchMethodError'
    var locationData = map['geometry']?['location'];
    double lat = locationData?['lat'] ?? 0.0; // Provide default values
    double lng = locationData?['lng'] ?? 0.0; // Provide default values

    String address = map['formatted_address'] ?? 'No address available';
    String phoneNumber =
        map['formatted_phone_number'] ?? 'No phone number available';
    double rating = (map['rating'] as num?)?.toDouble() ?? 0.0;

    List<String> reviews =
        (map['reviews'] as List?)?.map((r) => r['text'].toString()).toList() ??
            [];
    List<String> photoReferences = (map['photos'] as List?)
            ?.map((p) => p['photo_reference'].toString())
            .toList() ??
        [];

    return Place(
      name: map['name'] ?? 'Unknown Name',
      latitude: lat,
      longitude: lng,
      placeId: map['place_id'] ?? 'No ID',
      address: address,
      phoneNumber: phoneNumber,
      rating: rating,
      reviews: reviews,
      photoReferences: photoReferences,
    );
  }

  String getPhotoUrl(String photoReference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$GOOGLE_MAPS_API_KEY';
  }
}
