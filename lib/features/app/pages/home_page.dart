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
              isScrollControlled: false,
              isDismissible: true,
              backgroundColor: Colors.transparent,
              barrierColor: Colors
                  .transparent, // Ensure the dimming background is also transparent
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  initialChildSize:
                      0.25, // The initial size of the sheet when it's displayed.
                  minChildSize:
                      0.25, // The minimum size of the sheet when it's opened.
                  maxChildSize:
                      1.0, // The maximum size of the sheet when it's dragged upwards.
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors
                            .white, // The color of the modal's content area.
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                                20)), // Creates a rounded corner on the top edge of the modal.
                      ),
                      child: ListView(
                        controller:
                            scrollController, // Assign the provided ScrollController to the ListView.
                        children: <Widget>[
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[
                                    300], // The color of the drag handle indicator.
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Text(bar.name), // Display the name of the bar.
                          // Include more widgets to display additional details like reviews, images, opening times, etc.
                        ],
                      ),
                    );
                  },
                );
              },
            );

            // End of showModalBottomSheet
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
