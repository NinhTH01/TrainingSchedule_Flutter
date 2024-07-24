import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/data/network/weather/weather_api_base.dart';

class WeatherModelView {
  Future<Map<String, dynamic>> fetchAllData() async {
    final weather = await WeatherApiBase.getCurrentWeather();
    final weatherForecast = await WeatherApiBase.getHourlyForecast();
    return {
      'weather': weather,
      'weatherForecast': weatherForecast,
    };
  }
}

// Create a FutureProvider for the data from both APIs
final dataProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return WeatherModelView().fetchAllData();
});
