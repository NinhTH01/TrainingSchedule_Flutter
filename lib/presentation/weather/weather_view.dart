import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/constants/weather.dart';
import 'package:training_schedule/helper/string.dart';
import 'package:training_schedule/helper/time.dart';
import 'package:training_schedule/helper/weather_helper.dart';
import 'package:training_schedule/models/weather/weather.dart';
import 'package:training_schedule/models/weather/weather_forecast.dart';
import 'package:training_schedule/presentation/weather/components/weather_forcast.dart';
import 'package:training_schedule/presentation/weather/components/weather_status.dart';
import 'package:training_schedule/presentation/weather/components/weather_wind.dart';
import 'package:training_schedule/presentation/weather/weather_model_view.dart';

class WeatherView extends ConsumerStatefulWidget {
  const WeatherView({super.key});

  @override
  ConsumerState<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends ConsumerState<WeatherView> {
  final ScrollController _scrollController = ScrollController();
  // Final value for animation logic
  double _maxContainerHeight = 250;
  double _maxOffsetDescription = 60;
  double _maxOffsetMinimize = 100;
  // Variables

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set final value based on screen height
      var size = MediaQuery.of(context).size;
      var height = size.height;
      _maxContainerHeight = height * 0.3;
      _maxOffsetDescription = height * 0.07;
      _maxOffsetMinimize = height * 0.11;
    });
  }

  void _onScroll() {
    final containerHeight = _maxContainerHeight - _scrollController.offset;
    final height = containerHeight < _maxOffsetMinimize
        ? _maxOffsetMinimize
        : (containerHeight > _maxContainerHeight
            ? _maxContainerHeight
            : containerHeight);

    final opacity = 1.0 - (_scrollController.offset / _maxOffsetDescription);
    final descOpacity = opacity < 0 ? 0.0 : (opacity > 1 ? 1.0 : opacity);

    final minOpacity = (_scrollController.offset - _maxOffsetDescription) /
        (_maxOffsetMinimize - _maxOffsetDescription);
    final minimizeOpacity =
        minOpacity < 0 ? 0.0 : (minOpacity > 1 ? 1.0 : minOpacity);

    final scrollPadding =
        _scrollController.offset < _maxContainerHeight - _maxOffsetMinimize
            ? _scrollController.offset
            : _maxContainerHeight - _maxOffsetMinimize;

    ref.read(weatherViewProvider.notifier).updateAnimationState(
          containerHeight: height,
          descOpacity: descOpacity,
          minimizeOpacity: minimizeOpacity,
          scrollPadding: scrollPadding,
        );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String _getBackgroundImagePath(String weatherCondition) {
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
  Widget build(BuildContext context) {
    final weatherViewState = ref.watch(weatherViewProvider);

    return Scaffold(
      body: weatherViewState.dataStatus.when(
        data: (_) {
          final Weather? weather = weatherViewState.data?['weather'];
          final WeatherForecast? weatherForecast =
              weatherViewState.data?['weatherForecast'];

          final containerHeight = weatherViewState.animation.containerHeight;
          final descOpacity = weatherViewState.animation.descOpacity;
          final minimizeOpacity = weatherViewState.animation.minimizeOpacity;
          final scrollPadding = weatherViewState.animation.scrollPadding;

          final backgroundColor =
              WeatherHelper.getBackgroundColor(weather!.weather[0].main);

          return DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  _getBackgroundImagePath(weather.weather[0].main),
                ),
                fit: BoxFit
                    .cover, // Adjust the fit property to control how the image is resized to cover the container
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Start: Weather Detail
                  SizedBox(
                    height: containerHeight,
                    child: Column(
                      children: [
                        Text(
                          weather.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        containerHeight >
                                _maxContainerHeight - _maxOffsetDescription
                            ? Opacity(
                                opacity: descOpacity,
                                child: Column(
                                  children: [
                                    Text(
                                      '${weather.main.temp.round()}°',
                                      style: const TextStyle(
                                        fontSize: 60,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      weather.weather[0].description
                                          .capitalizeFirstLetter(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'H:${weather.main.tempMax.round()}  L:${weather.main.tempMin.round()}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Opacity(
                                opacity: minimizeOpacity,
                                child: Text(
                                  '${weather.main.temp.round()}° | ${weather.weather[0].description.capitalizeFirstLetter()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  // End: header Detail
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const _NoBounceScrollPhysics(),
                      padding: EdgeInsets.only(top: scrollPadding),
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // First item
                          weatherForecastWidget(weatherForecast!, weather),
                          weatherWindWidget(weather),
                          // Grid
                          GridView(
                            padding: const EdgeInsets.all(16.0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 24.0,
                              childAspectRatio: 1, // Width / Height ratio
                            ),
                            children: [
                              weatherStatusWidget(
                                'HUMIDITY',
                                weather.main.humidity == null
                                    ? null
                                    : '${weather.main.humidity}%',
                                backgroundColor,
                              ),
                              weatherStatusWidget(
                                'FEELS LIKE',
                                '${weather.main.feelsLike.round()}°',
                                backgroundColor,
                              ),
                              weatherStatusWidget(
                                'SUNSET',
                                unixToHHmm(weather.sys.sunset),
                                backgroundColor,
                              ),
                              weatherStatusWidget(
                                'SUNRISE',
                                unixToHHmm(weather.sys.sunrise),
                                backgroundColor,
                              ),
                              weatherStatusWidget(
                                'PRESSURE',
                                '${weather.main.pressure}\nhPa',
                                backgroundColor,
                              ),
                              weatherStatusWidget(
                                'VISIBILITY',
                                weather.visibility == null
                                    ? null
                                    : '${weather.visibility! / 1000} km',
                                backgroundColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stack) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _NoBounceScrollPhysics extends ClampingScrollPhysics {
  const _NoBounceScrollPhysics({super.parent});

  @override
  _NoBounceScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _NoBounceScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (value < position.pixels && position.pixels <= 0.0) {
      // Prevent scrolling up when already at the top
      return value - position.pixels;
    } else {
      return super.applyBoundaryConditions(position, value);
    }
  }
}
