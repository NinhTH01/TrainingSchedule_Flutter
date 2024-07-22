import 'package:flutter/material.dart';

import '../../../data/local/database/events_database.dart';
import '../../../models/event.dart';

class CalendarEventEditModelView {
  final TextEditingController controller = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();

  void addOrUpdateEvent(widget) async {
    EventsDatabase eventsDatabase = EventsDatabase();
    if (widget.isEdit) {
      final event = widget.event!.copy(
        createdTime: DateTime(widget.date.date.year, widget.date.date.month,
            widget.date.date.day, selectedTime.hour, selectedTime.minute),
        description: controller.text,
      );
      await eventsDatabase.update(event);
    } else {
      Event event = Event(
          createdTime: DateTime(widget.date.date.year, widget.date.date.month,
              widget.date.date.day, selectedTime.hour, selectedTime.minute),
          distance: 0,
          description: controller.text);

      await eventsDatabase.insert(event);
    }
  }

  void deleteEvent(widget, context) async {
    EventsDatabase eventsDatabase = EventsDatabase();

    await eventsDatabase.delete(widget.event?.id);

    Navigator.pop(context);
  }
}
