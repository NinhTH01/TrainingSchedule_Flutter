import 'dart:ui';

import 'package:training_schedule/const/weather.dart';
import 'package:training_schedule/const/weather_colors.dart';

Color getBackgroundColor(String weather) {
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
