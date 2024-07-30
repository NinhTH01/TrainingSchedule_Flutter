import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildHeader(
  DateTime currentDate,
  void Function() changeToNextMonth,
  void Function() changeToLastMonth,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: changeToLastMonth,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          DateFormat('MMMM').format(currentDate),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: changeToNextMonth,
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    ),
  );
}
