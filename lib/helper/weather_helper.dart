import 'package:flutter/material.dart';
import 'package:training_schedule/constants/weather.dart';
import 'package:training_schedule/constants/weather_colors.dart';

class WeatherHelper {
  static Color getBackgroundColor(String weather) {
    switch (weather) {
      case WeatherCondition.cloud:
        return WeatherColors.cloudColor;
      case WeatherCondition.thunderstorm:
        return WeatherColors.thunderColor;
      case WeatherCondition.rain:
        return WeatherColors.rainColor;
      case WeatherCondition.drizzle:
        return WeatherColors.drizzleColor;
      case WeatherCondition.clear:
        return WeatherColors.clearColor;
      default:
        return WeatherColors.clearColor;
    }
  }

  static Icon getWeatherIcon(String weatherCondition) {
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
}
