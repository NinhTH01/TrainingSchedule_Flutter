import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:training_schedule/data/local/database/events_database.dart';
import 'package:training_schedule/models/event.dart';

class MapViewModel {
  static double calculatePolylineDistance(List<LatLng> polylinePoints) {
    double totalDistance = 0.0;

    for (int i = 0; i < polylinePoints.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        polylinePoints[i].latitude,
        polylinePoints[i].longitude,
        polylinePoints[i + 1].latitude,
        polylinePoints[i + 1].longitude,
      );
    }
    addEventToDatabase(totalDistance);
    return totalDistance;
  }

  static void addEventToDatabase(double distance) async {
    Event event = Event(
        createdTime: DateTime.now(),
        distance: distance,
        description: "You have run ${distance.toStringAsFixed(2)} meters.");

    EventsDatabase eventsDatabase = EventsDatabase();

    await eventsDatabase.insert(event);
  }
}
