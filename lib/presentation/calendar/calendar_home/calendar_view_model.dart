import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/data/local/database/events_database.dart';
import 'package:training_schedule/models/calendar/calendar_date_info.dart';
import 'package:training_schedule/models/event.dart';
import 'package:training_schedule/models/event_day_info.dart';

class CalendarViewModel {
  late BuildContext context;

  // Calendar Events Stream Provider
  Stream<List<EventDayInfo>> getThisMonthDateListStream(DateTime date) async* {
    final controller = StreamController<List<EventDayInfo>>();

    // Fetch the data and add it to the stream
    await getThisMonthDateList(date).then(controller.add);

    yield* controller.stream;
  }

  Future<List<EventDayInfo>> getThisMonthDateList(DateTime currentDate) async {
    var firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    var weekday = firstDayOfMonth.weekday;
    var previousSunday = firstDayOfMonth.subtract(Duration(days: weekday - 1));

    var eventDateList = <EventDayInfo>[];
    for (var i = 0; i < 35; i++) {
      eventDateList.add(
        EventDayInfo(
          date: previousSunday.add(Duration(days: i)),
          hasEvent: false,
        ),
      );
    }

    return convertDatesAndHistoryToCalendarList(eventDateList);
  }

  Future<List<EventDayInfo>> convertDatesAndHistoryToCalendarList(
    List<EventDayInfo> dates,
  ) async {
    var items = <Event>[];

    await EventsDatabase()
        .getList()
        .then(
          (list) => {
            items = list,
          },
        )
        .catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Error when capturing map!!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      return error;
    });

    var calendarList = <EventDayInfo>[];

    for (var date in dates) {
      var isEvent = false;
      for (var item in items) {
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
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

final calendarStateProvider =
    StateNotifierProvider<CalendarStateNotifier, CalendarDateInfo>((ref) {
  return CalendarStateNotifier();
});

class CalendarStateNotifier extends StateNotifier<CalendarDateInfo> {
  CalendarStateNotifier()
      : super(
          CalendarDateInfo(
            currentDate: DateTime.now(),
            eventDayInfoList: [],
          ),
        ) {
    fetchAndUpdateDateList(state.currentDate);
  }

  void changeToLastMonth() {
    final newDate =
        DateTime(state.currentDate.year, state.currentDate.month - 1);
    fetchAndUpdateDateList(newDate);
  }

  void changeToNextMonth() {
    final newDate =
        DateTime(state.currentDate.year, state.currentDate.month + 1);
    fetchAndUpdateDateList(newDate);
  }

  Future<void> fetchAndUpdateDateList(DateTime newDate) async {
    // Assume you have an instance of CalendarViewModel
    final viewModel = CalendarViewModel();
    final list = await viewModel.getThisMonthDateList(newDate);
    state = CalendarDateInfo(
      currentDate: newDate,
      eventDayInfoList: list,
    );
  }
}
