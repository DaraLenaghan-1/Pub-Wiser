import 'dart:async';

import 'package:first_app/const.dart';
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
      LatLng(53.27453804687606, -9.049238146120606); //position of Galway City
  static const LatLng _pGalwayCitySpanishArch =
      LatLng(53.27022682627128, -9.053970096184496); //position of spanish arch
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
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition:
                  const CameraPosition(target: _pGalwayCity, zoom: 14),
              markers: _markers,
              polylines: Set<Polyline>.of(_polylines.values),
            ),
    );
  }

  Future<void> _goToCamPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition newCamPosition = CameraPosition(target: position, zoom: 14);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(newCamPosition),
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
          //_goToCamPosition(newPosition); -- Uncomment this line to center the map on the user's location
        }
      },
    );
  }

  Future<List<LatLng>> getPolyline() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(
          _pGalwayCitySpanishArch.latitude, _pGalwayCitySpanishArch.longitude),
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

  void updateMapMarkers(List<Place> bars) {
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

    // Adding markers for the bars
    for (var bar in bars) {
      var markerId = MarkerId(bar.name);
      var marker = Marker(
          markerId: markerId,
          position: LatLng(bar.latitude, bar.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: bar.name,
            snippet: 'Click for details',
          ),
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: false, // allows the modal to be full-screen
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  initialChildSize:
                      0.25, // 25% of the screen height when opened
                  minChildSize:
                      0.25, // Minimum size of the bottom sheet when opened
                  maxChildSize:
                      1, // It will cover the whole screen when user drags upwards
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      // Apply your desired styling here
                      child: ListView.builder(
                        controller:
                            scrollController, // Use the provided ScrollController
                        itemCount:
                            1, // Assuming you want to show only one item for now
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(bar.name),
                            subtitle: Text('Tap for details'),
                            onTap: () {
                              // Your code to navigate to the PubDetailsPage or expand the modal
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            );
          });
      newMarkers.add(marker);
    }
    setState(() {
      _markers.clear();
      _markers.addAll(newMarkers);
    });
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
