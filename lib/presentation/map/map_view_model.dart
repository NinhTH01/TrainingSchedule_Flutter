import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:training_schedule/data/local/database/events_database.dart';
import 'package:training_schedule/models/event.dart';
import 'package:training_schedule/models/map/map_state.dart';

class MapViewModel {
  static double calculatePolylineDistance(List<LatLng> polylinePoints) {
    var totalDistance = 0.0;

    for (var i = 0; i < polylinePoints.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        polylinePoints[i].latitude,
        polylinePoints[i].longitude,
        polylinePoints[i + 1].latitude,
        polylinePoints[i + 1].longitude,
      );
    }
    _addEventToDatabase(totalDistance);
    return totalDistance;
  }

  static Future<void> _addEventToDatabase(double distance) async {
    var event = Event(
      createdTime: DateTime.now(),
      distance: distance,
      description: 'You have run ${distance.toStringAsFixed(2)} meters.',
    );

    var eventsDatabase = EventsDatabase();

    await eventsDatabase.insert(event);
  }

  static Future<double> checkTotalDistance() async {
    var items = <Event>[];

    await EventsDatabase()
        .getList()
        .then(
          (list) => {
            items = list,
          },
        )
        .catchError((error) {
      return error;
    });

    var totalDistance = 0.0;

    for (var item in items) {
      totalDistance += item.distance;
    }

    return totalDistance;
  }
}

class MapStateNotifier extends StateNotifier<MapState> {
  final Location _locationController = Location();

  MapStateNotifier() : super(MapState()) {
    _init();
  }

  Future<void> _init() async {
    var serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    var permission = await _locationController.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _locationController.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged.listen((currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null &&
          state.isUpdating) {
        final newPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );

        state = state.copyWith(
          locationData: currentLocation,
        );

        if (state.isRunning) {
          state = state.copyWith(
            // locationData: currentLocation,
            polylineCoordinates: List.from(state.polylineCoordinates)
              ..add(newPosition),
            polylines: {
              Polyline(
                polylineId: const PolylineId('polyline'),
                visible: true,
                points: List.from(state.polylineCoordinates)..add(newPosition),
                color: Colors.blue,
                width: 4,
              ),
            },
          );
        }
        _moveCamera(newPosition);
      }
    });
  }

  void setMapController(GoogleMapController controller) {
    state = state.copyWith(mapController: controller);
  }

  Future<void> startStopTracking(
    Function(Uint8List, double, Function()) onScreenshotCaptured,
  ) async {
    final isRunning = state.isRunning;
    if (isRunning) {
      state = state.copyWith(isUpdating: false);
      final newDistance =
          MapViewModel.calculatePolylineDistance(state.polylineCoordinates);

      await _takeScreenshot(onScreenshotCaptured, newDistance);

      state = state.copyWith(
        polylines: {},
        polylineCoordinates: [],
      );
    }
    state = state.copyWith(isRunning: !state.isRunning);
  }

  void _moveCamera(LatLng position) {
    final controller = state.mapController;
    if (controller != null) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 18.0,
          ),
        ),
      );
    }
  }

  Future<void> _takeScreenshot(
    Function(Uint8List, double, Function()) onScreenshotCaptured,
    double distance,
  ) async {
    final controller = state.mapController;
    if (controller != null) {
      await _setCameraToPolylineBounds();
      await Future.delayed(const Duration(seconds: 1));
      final image = await controller.takeSnapshot();
      if (image != null) {
        onScreenshotCaptured(image, distance, () {
          state = state.copyWith(
            isUpdating: true,
          );
        });
      }
    }
  }

  Future<void> _setCameraToPolylineBounds() async {
    final controller = state.mapController;
    if (controller != null) {
      var bounds = _calculateBounds(state.polylineCoordinates);

      var cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 50);
      await controller.animateCamera(cameraUpdate);
    }
  }

  LatLngBounds _calculateBounds(List<LatLng> points) {
    var southWestLat = points[0].latitude;
    var southWestLng = points[0].longitude;
    var northEastLat = points[0].latitude;
    var northEastLng = points[0].longitude;

    for (var point in points) {
      if (point.latitude < southWestLat) {
        southWestLat = point.latitude;
      }
      if (point.longitude < southWestLng) {
        southWestLng = point.longitude;
      }
      if (point.latitude > northEastLat) {
        northEastLat = point.latitude;
      }
      if (point.longitude > northEastLng) {
        northEastLng = point.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );
  }
}

final mapStateProvider =
    StateNotifierProvider<MapStateNotifier, MapState>((ref) {
  return MapStateNotifier();
});
