import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/presentation/weather/weather_model_view.dart';

import '../../const/weather.dart';
import '../../models/weather/weather.dart';
import '../../models/weather/weather_forecast.dart';

class WeatherView extends ConsumerWidget {
  const WeatherView({super.key});

  String getBackgroundImagePath(String weatherCondition) {
    switch (weatherCondition) {
      case WeatherCondition.clear:
        return 'assets/weather_background/default.jpg';
      case WeatherCondition.cloud:
        return 'assets/weather_background/cloud.jpg';
      case WeatherCondition.drizzle:
        return 'assets/weather_background/drizzle.jpg';
      case WeatherCondition.rain:
        return 'assets/weather_background/rain.jpg';
      case WeatherCondition.thunderstorm:
        return 'assets/weather_background/lightning.jpg';
      default:
        return 'assets/weather_background/clear.jpg';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsyncValue = ref.watch(dataProvider);
    return Scaffold(
      body: dataAsyncValue.when(data: (data) {
        final Weather weather = data["weather"];
        final WeatherForecast weatherForecast = data["weatherForecast"];
        // print(weather.main);

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                getBackgroundImagePath(weather.weather[0].main),
                fit: BoxFit.cover,
              ),
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [Text("Center")],
            // )
          ],
        );
      }, error: (error, stack) {
        return Center(child: Text('Error: ${dataAsyncValue.error}'));
      }, loading: () {
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}

// class WeatherView extends StatefulWidget {
//   const WeatherView({super.key});
//
//   @override
//   State<WeatherView> createState() => _WeatherViewState();
// }
//
// class _WeatherViewState extends State<WeatherView> {
//   WeatherModelView modelView = WeatherModelView();
//   Future<Map<String, dynamic>>? data;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(0);
//     data = modelView.fetchAllData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//           future: data,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             } else if (snapshot.hasData) {
//               final data1 = snapshot.data!['weather']!;
//               final data2 = snapshot.data!['weatherForecast']!;
//               return Center(child: Text('Center'));
//             } else {
//               return Center(child: Text('No data'));
//             }
//           }),
//     );
//   }
// }
