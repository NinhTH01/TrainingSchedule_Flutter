import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/models/event.dart';
import 'package:training_schedule/models/event_day_info.dart';
import 'package:training_schedule/presentation/calendar/calendar_event_edit/calendar_event_edit_view_model.dart';

class CalendarEventEditView extends ConsumerWidget {
  final EventDayInfo date;
  final bool isEdit;
  final Event? event;

  const CalendarEventEditView({
    super.key,
    required this.date,
    required this.isEdit,
    this.event,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventNotifier = ref.watch(eventEditProvider(event));

    void showActionSheet() {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text('Delete Event'),
          message: const Text('Are you sure you want to proceed?'),
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                ref
                    .read(eventEditProvider(event).notifier)
                    .deleteEvent(event, context, () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
              child: const Text('Confirm'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                ref.invalidate(eventEditProvider(event));
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.invalidate(eventEditProvider(event));
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                Text(
                  isEdit ? 'Edit Event' : 'New Event',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(eventEditProvider(event).notifier)
                        .addOrUpdateEvent(
                          date: date,
                          isEdit: isEdit,
                          eventInfo: event,
                        );
                    ref.invalidate(eventEditProvider(event));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: eventNotifier.controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: eventNotifier.selectedTime,
                        initialEntryMode: TimePickerEntryMode.input,
                      );
                      if (timeOfDay != null) {
                        ref
                            .read(eventEditProvider(event).notifier)
                            .updateSelectedTime(timeOfDay);
                      }
                    },
                    child: Text(
                      eventNotifier.selectedTime.format(context),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            isEdit
                ? TextButton(
                    onPressed: showActionSheet,
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
