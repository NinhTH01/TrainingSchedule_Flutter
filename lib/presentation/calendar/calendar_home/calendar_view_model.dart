import 'package:training_schedule/data/local/database/events_database.dart';
import 'package:training_schedule/models/event_day_info.dart';

import '../../../models/event.dart';

class CalendarViewModel {
  List<EventDayInfo> listOfDateInMonth = [];

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
        .catchError((error) => print(error));

    List<EventDayInfo> calendarList = [];

    for (EventDayInfo date in dates) {
      bool isEvent = false;
      for (Event item in items) {
        if (isSameDay(date.date, item.createdTime)) {
          isEvent = true;
          break;
        }
      }
      calendarList.add(EventDayInfo(date: date.date, hasEvent: isEvent));
    }

    listOfDateInMonth = calendarList;

    return calendarList;
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
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
