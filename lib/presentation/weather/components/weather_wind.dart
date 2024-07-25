import 'package:flutter/material.dart';
import 'package:training_schedule/helper/get_background_color.dart';

import '../../../models/weather/weather.dart';

Widget weatherWindWidget(Weather weather) {
  return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: getBackgroundColor(weather.weather[0].main),
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'WIND',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Expanded(
                child:
                    windItemWidget(weather.wind.speed * 3.6, "KM/H", "Wind")),
            Expanded(
                child: windItemWidget(
                    weather.wind.deg, "Degrees", "Wind Direction"))
          ]),
          const Divider(),
          windItemWidget(
              weather.wind.gust == null ? null : weather.wind.gust! * 3.6,
              "KM/H",
              "Gusts")
        ],
      ));
}

Widget windItemWidget(num? value, String unit, String name) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(value == null ? "_" : value.round().toString(),
          style: const TextStyle(color: Colors.white, fontSize: 32)),
      const SizedBox(
        width: 8,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(unit,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
          Text(name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500))
        ],
      )
    ],
  );
}
