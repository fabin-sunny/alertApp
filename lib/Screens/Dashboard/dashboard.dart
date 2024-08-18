import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:taskez/Screens/Profile/profile_overview.dart';
import 'package:taskez/widgets/Navigation/dasboard_header.dart';

/*
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  LatLng? _currentP;
  GoogleMapController? _mapController;
  final Location _locationController = Location();

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (_mapController != null) {
            _mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _currentP!,
                  zoom: 14.4746,
                ),
              ),
            );
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: CircularProgressIndicator(), // Use CircularProgressIndicator to indicate loading
            )
          : Stack(
              children: [
                // The GoogleMap widget as the background layer
                GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                    target: _currentP!,
                    zoom: 14.4746,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: {
                    Marker(
                      markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentP!,
                    ),
                  },
                  circles: {
                    Circle(
                      circleId: CircleId("1"),
                      center: _currentP!,
                      radius: 430,
                      strokeWidth: 2,
                      fillColor: const Color.fromARGB(255, 71, 77, 246).withOpacity(0.2),
                    ),
                  },
                ),
                // The column with padding and other widgets as a foreground layer
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DashboardNav(
                            image: "assets/man-head.png",
                            title: "Alert Map",
                            onImageTapped: () {
                              Get.to(() => ProfileOverview());
                            },
                          ),
                          // Add more widgets here if needed
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
*/



class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  LatLng? _currentP;
  GoogleMapController? _mapController;
  final Location _locationController = Location();
  bool _isMapInitialized = false;
  StreamSubscription<LocationData>? _locationSubscription;

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        setState(() {
          _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          if (_mapController != null && !_isMapInitialized) {
            _mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: _currentP!,
                  zoom: 15.4746,
                ),
              ),
            );
            _isMapInitialized = true;
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  @override
  void dispose() {
    // Dispose of the location subscription to avoid memory leaks
    _locationSubscription?.cancel();
    // Dispose of the map controller if necessary
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: CircularProgressIndicator(), // Show loading while waiting for location
            )
          : Stack(
              children: [
                // The GoogleMap widget as the background layer
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _currentP ?? LatLng(0, 0), // Fallback to a default LatLng
                    zoom: 15.4746,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    if (_currentP != null) {
                      _mapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _currentP!,
                            zoom: 15.4746,
                          ),
                        ),
                      );
                      _isMapInitialized = true;
                    }
                  },
                  markers: {
                    if (_currentP != null)
                      Marker(
                        markerId: const MarkerId("_currentLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _currentP!,
                      ),
                  },
                  circles: {
                    if (_currentP != null)
                      Circle(
                        circleId: const CircleId("1"),
                        center: _currentP!,
                        radius: 430,
                        strokeWidth: 2,
                        fillColor: const Color.fromARGB(255, 71, 77, 246).withOpacity(0.2),
                      ),
                  },
                ),
                // The column with padding and other widgets as a foreground layer
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DashboardNav(
                            image: "assets/man-head.png",
                            title: "Alert Map",
                            onImageTapped: () {
                              Get.to(() => ProfileOverview());
                            },
                          ),
                          // Add more widgets here if needed
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

