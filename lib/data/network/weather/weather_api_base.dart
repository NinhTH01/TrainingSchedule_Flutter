import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:training_schedule/models/weather/weather.dart';
import 'package:training_schedule/models/weather/weather_forecast.dart';

@immutable
class WeatherApiBase {
  static const apiKey = String.fromEnvironment('WEATHER_API_KEY');
  static const baseUrl = 'https://api.openweathermap.org/data/2.5';

  static double lat = 0.0;
  static double lon = 0.0;
  static final dio = Dio();

  static String _constructWeatherUrl() =>
      '$baseUrl/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

  static String _constructForecastUrl() =>
      '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

  static Future<void> setLocation(Position location) async {
    lat = location.latitude;
    lon = location.longitude;
  }

  static Future<Weather> getCurrentWeather() async {
    final url = _constructWeatherUrl();
    final response = await _fetchData(url);
    return Weather.fromJson(response);
  }

  static Future<WeatherForecast> getHourlyForecast() async {
    final url = _constructForecastUrl();
    final response = await _fetchData(url);
    return WeatherForecast.fromJson(response);
  }

  static Future<Map<String, dynamic>> _fetchData(String url) async {
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        // print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // print('Error fetching data from $url: $e');
      throw Exception('Error fetching data');
    }
  }
}
