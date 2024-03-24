import 'dart:async';

import 'package:first_app/const.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGalwayCity =
      LatLng(53.27453804687606, -9.049238146120606); //position of Galway City
  static const LatLng _pGalwayCitySpanishArch =
      LatLng(53.27022682627128, -9.053970096184496); //position of spanish arch
  LatLng? _currentPosition = null;

  Map<PolylineId, Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPolyline().then((coordinates) => {
              setPolylines(coordinates),
            }),
      },
    );
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
                  CameraPosition(target: _pGalwayCity, zoom: 14),
              markers: {
                Marker(
                    markerId: MarkerId('_currentLocation'),
                    position: _currentPosition!),
                Marker(
                    markerId: MarkerId('_sourceLocation'),
                    position: _pGalwayCitySpanishArch),
                Marker(
                    markerId: MarkerId('_destination'), //_destination
                    position: _pGalwayCity),
                Marker(
                    markerId: MarkerId('_sourceLocation'),
                    position: _pGalwayCitySpanishArch)
              },
              polylines: Set<Polyline>.of(_polylines.values),
            ),
    );
  }

  Future<void> _goToCamPosition(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCamPosition = CameraPosition(target: position, zoom: 14);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCamPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }
    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _goToCamPosition(_currentPosition!);
          print(_currentPosition);
        });
      }
    });
  }

  Future<List<LatLng>> getPolyline() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(
          _pGalwayCitySpanishArch.latitude, _pGalwayCitySpanishArch!.longitude),
      PointLatLng(_pGalwayCity.latitude, _pGalwayCity.longitude),
      travelMode: TravelMode.walking,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void setPolylines(List<LatLng> polylineCoordinates) async {
    // List<LatLng> polylineCoordinates = await getPolyline();
    PolylineId id = PolylineId("poly");
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
}
