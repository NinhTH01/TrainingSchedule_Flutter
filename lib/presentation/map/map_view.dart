import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:training_schedule/presentation/map/map_view_model.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // Variable and const
  final _locationController = Location();

  late GoogleMapController _googleMapController;

  final Set<Polyline> _polylines = {};

  final List<LatLng> _polylineCoordinates = [];

  LatLng? _currentPosition;

  bool _isRunning = false;

  bool _isUpdating = true;

  double _distance = 0.0;

  // LifeCycle
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => await _fetchLocationUpdates());
  }

  // Function
  void _onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    _locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        if (_isUpdating && mounted) {
          setState(() {
            controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                target: LatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                zoom: 18.0)));
          });
        }
      }
    });
  }

  Future<void> _fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        if (_isUpdating && mounted) {
          setState(() {
            _currentPosition = LatLng(
              currentLocation.latitude!,
              currentLocation.longitude!,
            );

            if (_isRunning) {
              _polylineCoordinates.add(LatLng(
                currentLocation.latitude!,
                currentLocation.longitude!,
              ));

              _polylines.add(
                Polyline(
                  polylineId: const PolylineId('polyline'),
                  visible: true,
                  points: _polylineCoordinates,
                  color: Colors.blue,
                  width: 4,
                ),
              );
            }
          });
        }
      }
    });
  }

  Future<void> _setCameraToPolylineBounds() async {
    LatLngBounds bounds = calculateBounds(_polylineCoordinates);

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
    await _googleMapController.animateCamera(cameraUpdate);
  }

  LatLngBounds calculateBounds(List<LatLng> points) {
    double southWestLat = points[0].latitude;
    double southWestLng = points[0].longitude;
    double northEastLat = points[0].latitude;
    double northEastLng = points[0].longitude;

    for (var point in points) {
      if (point.latitude < southWestLat) southWestLat = point.latitude;
      if (point.longitude < southWestLng) southWestLng = point.longitude;
      if (point.latitude > northEastLat) northEastLat = point.latitude;
      if (point.longitude > northEastLng) northEastLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }

  void _takeScreenshot() async {
    await _setCameraToPolylineBounds();
    await Future.delayed(const Duration(
        seconds:
            1)); // Delay to wait for camera animate so can capture the polylines.
    _googleMapController.takeSnapshot().then((image) {
      if (image != null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                children: [
                  Expanded(child: Image.memory(image)),
                  Text("You have run ${_distance.toStringAsFixed(2)} meters")
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    _isUpdating = true;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }).catchError((onError) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Error when capturing map!!"),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  _isUpdating = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 18.0,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('Id'),
                      position: _currentPosition!,
                    )
                  },
                  polylines: _polylines,
                ),
          Positioned(
              bottom: 16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding:
                      const EdgeInsets.all(24), // Adjust the padding as needed
                ),
                onPressed: () {
                  if (_currentPosition != null) {
                    if (_isRunning) {
                      _isUpdating = false;
                      _distance = MapViewModel.calculatePolylineDistance(
                          _polylineCoordinates);
                      _takeScreenshot();
                      _polylines.clear();
                      _polylineCoordinates.clear();
                    }
                    _isRunning = !_isRunning;
                  }
                },
                child: Text(_isRunning ? "Stop" : "Start",
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500)),
              ))
        ],
      ),
    );
  }
}
