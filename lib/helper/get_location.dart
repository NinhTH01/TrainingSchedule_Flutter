// import 'package:location/location.dart';
//
// Future<LocationData> getLocation() async {
//   final controller = Location();
//
//   bool serviceEnabled;
//   PermissionStatus permissionGranted;
//
//   print(0);
//
//   serviceEnabled = await controller.serviceEnabled();
//   if (serviceEnabled) {
//     print(1);
//     serviceEnabled = await controller.requestService();
//   } else {
//     print(2);
//     return Future.error("Location service is not enabled");
//   }
//
//   permissionGranted = await controller.hasPermission();
//   if (permissionGranted == PermissionStatus.denied) {
//     print(permissionGranted);
//
//     permissionGranted = await controller.requestPermission();
//     print(3);
//     if (permissionGranted != PermissionStatus.granted) {
//       print(4);
//       return Future.error("Location permission are denied");
//     }
//   }
//   print(5);
//   return await controller.getLocation();
// }
import 'package:geolocator/geolocator.dart';

Future<Position> getLocation() async {
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  return await Geolocator.getCurrentPosition();
}
