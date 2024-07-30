import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildWeek() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Expanded(
          child: buildWeekDay('Mon'),
        ),
        Expanded(
          child: buildWeekDay('Tue'),
        ),
        Expanded(
          child: buildWeekDay('Wed'),
        ),
        Expanded(
          child: buildWeekDay('Thu'),
        ),
        Expanded(
          child: buildWeekDay('Fri'),
        ),
        Expanded(
          child: buildWeekDay('Sat'),
        ),
        Expanded(
          child: buildWeekDay('Sun'),
        ),
      ],
    ),
  );
}

Widget buildWeekDay(String day) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Center(
      child: Text(
        day,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0),
      ),
    ),
  );
}
