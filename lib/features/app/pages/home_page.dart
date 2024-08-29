import 'dart:async';
import 'dart:ui' as ui;
import 'package:first_app/const.dart';
import 'package:first_app/models/drink.dart';
import 'package:first_app/models/pub.dart';
import 'package:first_app/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:first_app/services/google_places_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GooglePlacesClient placesClient = GooglePlacesClient();

  final Location _locationController = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGalwayCity =
      LatLng(53.27453804687606, -9.049238146120606); // Position of Galway City
  LatLng? _currentPosition;

  final Map<PolylineId, Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  BitmapDescriptor? userLocationIcon;

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
    fetchBarsAndDisplay();
    loadCustomMarker();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel(); // Cancel location subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
                setState(
                    () {}); // Trigger a rebuild to ensure markers are displayed
              },
              initialCameraPosition:
                  const CameraPosition(target: _pGalwayCity, zoom: 14),
              markers: _markers,
              polylines: Set<Polyline>.of(_polylines.values),
            ),
    );
  }

  Future<void> getLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _locationController.onLocationChanged.listen(
      (LocationData currentLocation) {
        if (!mounted) return;
        double? lat = currentLocation.latitude;
        double? lng = currentLocation.longitude;
        if (lat != null && lng != null) {
          LatLng newPosition = LatLng(lat, lng);
          setState(() {
            _currentPosition = newPosition;
            // Update or add the user location marker
            _markers.removeWhere(
                (m) => m.markerId == const MarkerId('_currentLocation'));
            _markers.add(Marker(
              markerId: const MarkerId('_currentLocation'),
              position: newPosition,
              icon: userLocationIcon ?? BitmapDescriptor.defaultMarker,
              infoWindow: const InfoWindow(title: 'Your Location'),
            ));
          });
        }
      },
    );
  }

  Future<List<LatLng>> getPolyline() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_pGalwayCity.latitude, _pGalwayCity.longitude),
      PointLatLng(_pGalwayCity.latitude, _pGalwayCity.longitude),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void setPolylines(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    setState(() {
      _polylines[id] = polyline;
    });
  }

  void fetchBarsAndDisplay() async {
    try {
      var bars = await placesClient.fetchBars(
          53.2745, -9.0493); // Coordinates for Galway City
      updateMapMarkers(bars);
    } catch (e) {
      print('Error fetching bars: $e');
    }
  }

  void updateMapMarkers(List<Place> bars) async {
    var newMarkers = <Marker>{};

    // Adding a marker for the user's current location with a custom icon
    if (_currentPosition != null) {
      newMarkers.add(Marker(
        markerId: const MarkerId('_currentLocation'),
        position: _currentPosition!,
        icon: userLocationIcon ??
            BitmapDescriptor.defaultMarker, // Use custom icon if loaded
        infoWindow: const InfoWindow(title: 'Your Location'),
      ));
    }

    for (var bar in bars) {
      var markerId = MarkerId(bar.name);

      // Fetch drink prices for the current bar
      var pub = await FirestoreService().getPubByTitle(bar.name);
      double guinnessPrice = 0.0;
      List<Drink> drinks = [];

      if (pub != null) {
        drinks = await FirestoreService().getDrinkPrices(pub.id);
        // Assuming "Guinness" is the name of the drink we are interested in
        var guinness = drinks.firstWhere(
          (drink) => drink.name.toLowerCase() == 'Guinness'.toLowerCase(),
          orElse: () => Drink(name: 'Guinness', price: 0.0),
        );
        guinnessPrice = guinness.price;
      }

      // Create a custom marker with the Guinness price
      final markerIcon =
          await createCustomMarker(guinnessPrice.toStringAsFixed(2));

      var marker = Marker(
        markerId: markerId,
        position: LatLng(bar.latitude, bar.longitude),
        icon: markerIcon,
        onTap: () async {
          // Display details when marker is tapped
          try {
            var placeDetails =
                await placesClient.fetchPlaceDetails(bar.placeId);
            if (pub != null) {
              showModalWithDrinkPrices(context, pub, drinks, placeDetails);
            } else {
              // Show the modal with the pub/bar name and "No matching pubs found in database"
              showModalWithErrorMessage(
                context,
                "No matching pubs found in database for ${bar.name}.",
              );
            }
          } catch (e) {
            print("Failed to fetch place details: $e");
          }
        },
      );
      newMarkers.add(marker);
    }

    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
    });
  }

  Future<BitmapDescriptor> createCustomMarker(String price) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.black; // Black background color
    final double width = 100;
    final double height = 50; // Adjust height for the capsule shape

    // Draw the capsule-shaped marker with a black background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(0.0, 0.0, width, height), Radius.circular(height / 2)),
      paint,
    );

    // Draw the price text in white for contrast
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: '€$price',
      style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold), // White text color
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset((width - textPainter.width) / 2,
            (height - textPainter.height) / 2));

    final img = await pictureRecorder
        .endRecording()
        .toImage(width.toInt(), height.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void showModalWithDrinkPrices(BuildContext context, Pub pub,
      List<Drink> drinks, Place placeDetails) async {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.25,
            maxChildSize: 0.85,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          placeDetails.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Center(
                        child: Text(
                            'Address: ${placeDetails.address ?? "Not available"}',
                            textAlign: TextAlign.center)),
                    Center(
                        child: Text(
                            'Phone: ${placeDetails.phoneNumber ?? "Not available"}',
                            textAlign: TextAlign.center)),
                    Center(
                        child: Text(
                            'Rating: ${placeDetails.rating?.toString() ?? "Not rated"}',
                            textAlign: TextAlign.center)),
                    Center(
                      child: Text(pub.description ?? 'No description available',
                          textAlign: TextAlign.center),
                    ),
                    // SizedBox for spacing
                    SizedBox(height: 10),
                    Divider(
                        color: Colors.grey,
                        thickness: 2), // Line separating sections
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Drink Prices',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    // Listing the drink prices
                    ...drinks.map(
                      (drink) => ListTile(
                        title: Center(
                            child:
                                Text(drink.name, textAlign: TextAlign.center)),
                        trailing: Text('€${drink.price.toStringAsFixed(2)}',
                            textAlign: TextAlign.center),
                      ),
                    ),
                    Divider(color: Colors.grey, thickness: 2),
                    // Gallery section (conditionally rendered)
                    if (placeDetails.photoReferences?.isNotEmpty ?? false)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            'Gallery',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (placeDetails.photoReferences?.isNotEmpty ?? false)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        itemCount: placeDetails.photoReferences?.length ?? 0,
                        itemBuilder: (context, index) {
                          var photoRef = placeDetails.photoReferences?[index];
                          var photoUrl = photoRef != null
                              ? placeDetails.getPhotoUrl(photoRef)
                              : '';
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.network(photoUrl, fit: BoxFit.cover),
                          );
                        },
                      ),
                    SizedBox(
                        height: 20), // Spacing after the drink prices section

                    Divider(
                        color: Colors.grey,
                        thickness: 2), // Line before the reviews section
                    ...placeDetails.reviews?.map(
                          (review) => ListTile(
                            title: Text('Review', textAlign: TextAlign.center),
                            subtitle: Text(review, textAlign: TextAlign.center),
                          ),
                        ) ??
                        [],
                    ...placeDetails.photoReferences?.map((photoRef) {
                          var photoUrl = placeDetails.getPhotoUrl(photoRef);
                          return Center(
                              child: Image.network(photoUrl, height: 200));
                        }) ??
                        [],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void showModalWithErrorMessage(BuildContext context, String message) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text(message),
          ),
        );
      },
    );
  }

  void loadCustomMarker() async {
    try {
      userLocationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5),
          'assets/user_location.png');
      setState(() {
        // Trigger a rebuild to update the map with the new icon
      });
    } catch (e) {
      print('Failed to load user location icon: $e');
    }
  }
}
