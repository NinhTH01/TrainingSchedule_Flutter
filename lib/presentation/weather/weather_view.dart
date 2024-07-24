import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/providers/current_weather_provider.dart';

import '../../providers/forecast_weather_provider.dart';

class WeatherView extends ConsumerWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(currentWeatherProvider);
    final weatherForecast = ref.watch(forecastWeatherProvider);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("${weatherData.valueOrNull?.name}"),
          // Text("${weatherForecast.valueOrNull?.city?.name}")
        ],
      ),
    );
  }
}
