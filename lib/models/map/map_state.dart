import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapState {
  final LocationData? locationData;
  final List<LatLng> polylineCoordinates;
  final Set<Polyline> polylines;
  final GoogleMapController? mapController;
  final bool isRunning;
  late final bool isUpdating;

  MapState({
    this.locationData,
    this.polylineCoordinates = const [],
    this.polylines = const {},
    this.mapController,
    this.isRunning = false,
    this.isUpdating = true,
  });

  MapState copyWith(
      {LocationData? locationData,
      List<LatLng>? polylineCoordinates,
      Set<Polyline>? polylines,
      GoogleMapController? mapController,
      bool? isRunning,
      bool? isUpdating}) {
    return MapState(
      locationData: locationData ?? this.locationData,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      polylines: polylines ?? this.polylines,
      mapController: mapController ?? this.mapController,
      isRunning: isRunning ?? this.isRunning,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}
