import 'package:location/location.dart';

Future<LocationData> getLocation() async {
  final controller = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await controller.serviceEnabled();
  if (serviceEnabled) {
    serviceEnabled = await controller.requestService();
  } else {
    return Future.error("Location service is not enabled");
  }

  permissionGranted = await controller.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await controller.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return Future.error("Location permission are denied");
    }
  }

  return await controller.getLocation();
}
