import 'package:flutter/material.dart';

class EventEditState {
  final TimeOfDay selectedTime;
  final TextEditingController controller;

  EventEditState({
    required this.selectedTime,
    required this.controller,
  });
}
