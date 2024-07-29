import 'package:flutter/material.dart';
import 'package:training_schedule/const/weather.dart';

Icon getWeatherIcon(String weatherCondition) {
  switch (weatherCondition) {
    case WeatherCondition.clear:
      return const Icon(Icons.wb_sunny, size: 20.0, color: Colors.yellow);
    case WeatherCondition.cloud:
      return const Icon(Icons.cloud, size: 20.0, color: Colors.grey);
    case WeatherCondition.thunderstorm:
      return const Icon(Icons.flash_on, size: 20.0, color: Colors.orange);
    case WeatherCondition.rain:
      return const Icon(Icons.beach_access, size: 20.0, color: Colors.white);
    case WeatherCondition.drizzle:
      return const Icon(Icons.grain, size: 20.0, color: Colors.lightBlue);
    default:
      return const Icon(Icons.cloud, size: 20.0, color: Colors.grey);
  }
}
