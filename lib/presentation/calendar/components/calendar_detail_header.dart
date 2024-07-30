import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_schedule/models/event.dart';
import 'package:training_schedule/models/event_day_info.dart';

Widget calendarDetailHeader(
  BuildContext context,
  EventDayInfo date,
  Function({required bool isEdit, Event? event}) onAddButtonPressed,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      Text(
        DateFormat('dd MMMM yyyy').format(date.date),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
      IconButton(
        onPressed: () {
          onAddButtonPressed(isEdit: false, event: null);
        },
        icon: const Icon(Icons.add),
      ),
    ],
  );
}
