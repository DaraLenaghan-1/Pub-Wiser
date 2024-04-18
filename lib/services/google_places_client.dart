import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:first_app/const.dart';

class GooglePlacesClient {
  final http.Client httpClient = http.Client();

  Future<List<Place>> fetchBars(double latitude, double longitude) async {
    const int radius = 1500;  // Radius in meters
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    String url = '$baseUrl?location=$latitude,$longitude&radius=$radius&type=bar&keyword=pub&key=$GOOGLE_MAPS_API_KEY';

    var response = await httpClient.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 'OK') {
        return (data['results'] as List).map((result) => Place.fromMap(result)).toList();
      } else {
        throw Exception('Failed to load bars: ${data['error_message']}');
      }
    } else {
      throw Exception('Failed to make API call with status: ${response.statusCode}');
    }
  }
}

class Place {
  final String name;
  final double latitude;
  final double longitude;

  Place({required this.name, required this.latitude, required this.longitude});

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      name: map['name'],
      latitude: map['geometry']['location']['lat'],
      longitude: map['geometry']['location']['lng'],
    );
  }
}
