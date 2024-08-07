import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/data/network/weather/weather_api_base.dart';
import 'package:training_schedule/presentation/weather/weather_view_state.dart';

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

class WeatherViewNotifier extends StateNotifier<WeatherViewState> {
  WeatherViewNotifier()
      : super(
          WeatherViewState(
            data: null,
            animation: WeatherAnimationState(
              containerHeight: 250.0,
              descOpacity: 1.0,
              minimizeOpacity: 0.0,
              scrollPadding: 0.0,
            ),
            dataStatus: const AsyncValue.loading(),
          ),
        ) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await WeatherModelView().fetchAllData();
      state = state.copyWith(
        data: data,
        dataStatus: const AsyncValue.data(null),
      );
    } catch (e, s) {
      state = state.copyWith(
        dataStatus: AsyncValue.error(e, s),
      );
    }
  }

  void updateAnimationState({
    double? containerHeight,
    double? descOpacity,
    double? minimizeOpacity,
    double? scrollPadding,
  }) {
    state = state.copyWith(
      animation: state.animation.copyWith(
        containerHeight: containerHeight,
        descOpacity: descOpacity,
        minimizeOpacity: minimizeOpacity,
        scrollPadding: scrollPadding,
      ),
    );
  }
}

// Create a FutureProvider for the data from both APIs
final weatherViewProvider =
    StateNotifierProvider<WeatherViewNotifier, WeatherViewState>((ref) {
  return WeatherViewNotifier();
});
