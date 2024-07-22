import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget calendarDetailHeader(context, widget, onAddButtonPressed) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios)),
      Text(
        DateFormat('dd MMMM yyyy').format(widget.date.date),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
      IconButton(
          onPressed: () {
            onAddButtonPressed(false, null);
          },
          icon: const Icon(Icons.add)),
    ],
  );
}
