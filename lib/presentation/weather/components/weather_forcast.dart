import 'package:flutter/material.dart';
import 'package:training_schedule/helper/background_color.dart';
import 'package:training_schedule/helper/weather_icon.dart';

import '../../../helper/time.dart';
import '../../../models/weather/weather.dart';
import '../../../models/weather/weather_forecast.dart';

Widget weatherForecastWidget(WeatherForecast weatherForecast, Weather weather) {
  return Container(
      height: 150,
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: getBackgroundColor(weather.weather[0].main),
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Weather Forecast for next 5 days /3 hours",
            style: TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.start,
          ),
          const Divider(),
          Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // padding: 12.0,
                  itemCount: weatherForecast.list.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 24.0, top: 4.0),
                        child: Column(
                          children: [
                            Text(unixToHH(weatherForecast.list[index].dt),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: getWeatherIcon(
                                  weatherForecast.list[index].weather[0].main),
                            ),
                            Text(
                                "${weatherForecast.list[index].main.temp.round()}°",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500))
                          ],
                        ));
                  }))
        ],
      ));
}
