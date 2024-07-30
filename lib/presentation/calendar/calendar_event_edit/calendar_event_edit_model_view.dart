import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/data/local/database/events_database.dart';
import 'package:training_schedule/models/calendar/event_edit_state.dart';
import 'package:training_schedule/models/event.dart';
import 'package:training_schedule/models/event_day_info.dart';

final eventEditProvider =
    StateNotifierProvider.family<EventEditNotifier, EventEditState, Event?>(
        (ref, eventInfo) {
  return EventEditNotifier(eventInfo);
});

class EventEditNotifier extends StateNotifier<EventEditState> {
  EventEditNotifier(Event? eventInfo)
      : super(
          EventEditState(
            selectedTime: TimeOfDay.fromDateTime(
              eventInfo?.createdTime ?? DateTime.now(),
            ),
            controller:
                TextEditingController(text: eventInfo?.description ?? ''),
          ),
        );

  void updateSelectedTime(TimeOfDay timeOfDay) {
    state = EventEditState(
      selectedTime: timeOfDay,
      controller: state.controller,
    );
  }

  void clearState() {
    state = EventEditState(
      selectedTime: TimeOfDay.fromDateTime(DateTime.now()),
      controller: TextEditingController(text: ''),
    );
  }

  Future<void> addOrUpdateEvent({
    required EventDayInfo date,
    required bool isEdit,
    Event? eventInfo,
  }) async {
    final eventsDatabase = EventsDatabase();
    final selectedTime = state.selectedTime;
    final description = state.controller.text;

    if (isEdit) {
      final event = eventInfo!.copy(
        createdTime: DateTime(
          date.date.year,
          date.date.month,
          date.date.day,
          selectedTime.hour,
          selectedTime.minute,
        ),
        description: description,
      );
      await eventsDatabase.update(event);
    } else {
      final event = Event(
        createdTime: DateTime(
          date.date.year,
          date.date.month,
          date.date.day,
          selectedTime.hour,
          selectedTime.minute,
        ),
        distance: 0,
        description: description,
      );
      await eventsDatabase.insert(event);
    }
  }

  Future<void> deleteEvent(
    Event? eventInfo,
    BuildContext context,
    Function() goBack,
  ) async {
    if (eventInfo != null) {
      final eventsDatabase = EventsDatabase();
      await eventsDatabase.delete(eventInfo.id);
      goBack();
    }

    // Navigator.pop(context);
  }
}
