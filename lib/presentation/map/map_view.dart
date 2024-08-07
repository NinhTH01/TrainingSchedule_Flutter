import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:training_schedule/data/local/shared_preference/achievement_preference.dart';
import 'package:training_schedule/presentation/map/map_view_model.dart';

class MapView extends ConsumerWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapStateProvider);
    final mapStateNotifier = ref.watch(mapStateProvider.notifier);

    void showAchieveDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const SimpleDialog(
            children: [
              Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: UiKitView(
                    viewType: 'congratulation_view',
                    creationParams: {},
                    creationParamsCodec: StandardMessageCodec(),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    void showFinishDialog(
      Uint8List image,
      double distance,
      Function() toggleUpdate,
    ) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Image.memory(image)),
                Text('You have run ${distance.toStringAsFixed(2)} meters'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  toggleUpdate();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      MapViewModel.checkTotalDistance().then((totalDistance) async {
        final hasAchieved = await AchievementPreference.getAchievement();
        if (!hasAchieved && totalDistance > 100.0) {
          await AchievementPreference.setAchievement(value: true);
          showAchieveDialog();
        }
      });
    }

    return Scaffold(
      body: mapState.locationData == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  onMapCreated: mapStateNotifier.setMapController,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      mapState.locationData!.latitude!,
                      mapState.locationData!.longitude!,
                    ),
                    zoom: 18.0,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('Id'),
                      position: LatLng(
                        mapState.locationData!.latitude!,
                        mapState.locationData!.longitude!,
                      ),
                    ),
                  },
                  polylines: mapState.polylines,
                ),
                Positioned(
                  bottom: 16,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                    ),
                    onPressed: () =>
                        mapStateNotifier.startStopTracking(showFinishDialog),
                    child: Text(
                      mapState.isRunning ? 'Stop' : 'Start',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
