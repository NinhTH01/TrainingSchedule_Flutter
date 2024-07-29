import 'package:flutter/material.dart';
import 'package:training_schedule/data/local/database/events_database.dart';
import 'package:training_schedule/models/event_day_info.dart';

import '../../../models/event.dart';

class CalendarViewModel {
  late BuildContext context;

  // Calendar Events Stream Provider
  Stream<List<EventDayInfo>> getThisMonthDateListStream(
      DateTime dateTime) async* {
    // Replace the following with actual implementation to get a stream of data
    // For example, if you fetch data periodically or on some event, you can yield data here
    List<EventDayInfo> list = await getThisMonthDateList(dateTime);
    yield list; // Emit the list of EventDayInfo
  }

  Future<List<EventDayInfo>> getThisMonthDateList(DateTime currentDate) async {
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    int weekday = firstDayOfMonth.weekday;
    DateTime previousSunday =
        firstDayOfMonth.subtract(Duration(days: weekday - 1));

    List<EventDayInfo> eventDateList = [];
    for (int i = 0; i < 35; i++) {
      eventDateList.add(EventDayInfo(
          date: previousSunday.add(Duration(days: i)), hasEvent: false));
    }

    return convertDatesAndHistoryToCalendarList(eventDateList);
  }

  Future<List<EventDayInfo>> convertDatesAndHistoryToCalendarList(
      List<EventDayInfo> dates) async {
    List<Event> items = [];

    await EventsDatabase()
        .getList()
        .then((list) => {
              items = list,
            })
        .catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Error when capturing map!!"),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });

    List<EventDayInfo> calendarList = [];

    for (EventDayInfo date in dates) {
      bool isEvent = false;
      for (Event item in items) {
        if (_isSameDay(date.date, item.createdTime)) {
          isEvent = true;
          break;
        }
      }
      calendarList.add(EventDayInfo(date: date.date, hasEvent: isEvent));
    }

    return calendarList;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    final DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
