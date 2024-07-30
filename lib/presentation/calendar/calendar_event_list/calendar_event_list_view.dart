import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:training_schedule/models/event.dart';
import 'package:training_schedule/models/event_day_info.dart';
import 'package:training_schedule/presentation/calendar/calendar_event_edit/calendar_event_edit_view.dart';
import 'package:training_schedule/presentation/calendar/calendar_event_list/calendar_event_list_view_model.dart';
import 'package:training_schedule/presentation/calendar/components/calendar_detail_header.dart';

class CalendarEventListView extends ConsumerWidget {
  final EventDayInfo date;

  const CalendarEventListView({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventListAsyncValue = ref.watch(eventListProvider(date.date));

    void goToEventEditView({required bool isEdit, Event? event}) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CalendarEventEditView(
            date: date,
            isEdit: isEdit,
            event: event,
          ),
        ),
      ).then((_) {
        // To refresh the event list, you could re-fetch it
        ref.invalidate(eventListProvider(date.date));
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            calendarDetailHeader(context, date, goToEventEditView),
            Expanded(
              child: eventListAsyncValue.when(
                data: (eventList) => ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return eventItemList(eventList[index], goToEventEditView);
                  },
                  itemCount: eventList.length,
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, stackTrace) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget eventItemList(
  Event event,
  void Function({required bool isEdit, Event? event}) onTap,
) {
  var timeInHHmm = DateFormat('HH:mm').format(event.createdTime);
  return GestureDetector(
    child: Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: Colors.black),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeInHHmm,
            style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          ),
          Text(
            event.description,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
    onTap: () {
      onTap(isEdit: true, event: event);
    },
  );
}
