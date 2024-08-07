import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeatherViewState {
  final Map<String, dynamic>? data; // Holds both weather and weatherForecast
  final WeatherAnimationState animation;
  final AsyncValue<void> dataStatus;

  WeatherViewState({
    this.data,
    required this.animation,
    required this.dataStatus,
  });

  WeatherViewState copyWith({
    Map<String, dynamic>? data,
    WeatherAnimationState? animation,
    AsyncValue<void>? dataStatus,
  }) {
    return WeatherViewState(
      data: data ?? this.data,
      animation: animation ?? this.animation,
      dataStatus: dataStatus ?? this.dataStatus,
    );
  }
}

class WeatherAnimationState {
  final double containerHeight;
  final double descOpacity;
  final double minimizeOpacity;
  final double scrollPadding;

  WeatherAnimationState({
    required this.containerHeight,
    required this.descOpacity,
    required this.minimizeOpacity,
    required this.scrollPadding,
  });

  WeatherAnimationState copyWith({
    double? containerHeight,
    double? descOpacity,
    double? minimizeOpacity,
    double? scrollPadding,
  }) {
    return WeatherAnimationState(
      containerHeight: containerHeight ?? this.containerHeight,
      descOpacity: descOpacity ?? this.descOpacity,
      minimizeOpacity: minimizeOpacity ?? this.minimizeOpacity,
      scrollPadding: scrollPadding ?? this.scrollPadding,
    );
  }
}
