import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/models/weather/weather_forecast.dart';
import 'package:training_schedule/presentation/weather/weather_model_view.dart';

import '../../models/weather/weather.dart';

class WeatherView extends ConsumerWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsyncValue = ref.watch(dataProvider);
    return Scaffold(
      body: dataAsyncValue.when(data: (data) {
        final Weather weather = data["weather"]!;
        final WeatherForecast weatherForecast = data["weatherForecast"];

        print(weather.name);
        print(weatherForecast.city?.name);
        return const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Center")],
          ),
        );
      }, error: (error, stack) {
        return Center(child: Text('Error: ${dataAsyncValue.error}'));
      }, loading: () {
        return const CircularProgressIndicator();
      }),
    );
  }
}
