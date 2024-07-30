import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/data/local/database/events_database.dart';
import 'package:training_schedule/models/event_day_info.dart';

import '../../../models/calendar/calendar_state.dart';
import '../../../models/event.dart';

class CalendarViewModel {
  late BuildContext context;

  // Calendar Events Stream Provider
  Stream<List<EventDayInfo>> getThisMonthDateListStream(DateTime date) async* {
    final controller = StreamController<List<EventDayInfo>>();

    // Fetch the data and add it to the stream
    await getThisMonthDateList(date).then((list) {
      controller.add(list);
    });

    yield* controller.stream;
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

      return error;
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

final calendarStateProvider =
    StateNotifierProvider<CalendarStateNotifier, CalendarState>((ref) {
  return CalendarStateNotifier();
});

class CalendarStateNotifier extends StateNotifier<CalendarState> {
  CalendarStateNotifier()
      : super(CalendarState(
          currentDate: DateTime.now(),
          dateList: [],
        )) {
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
    state = CalendarState(
      currentDate: newDate,
      dateList: list,
    );
  }
}
