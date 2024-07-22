import 'package:flutter/material.dart';
import 'package:training_schedule/models/event_day_info.dart';

import '../calendar_home/calendar_view_model.dart';

Widget buildCalendar(
  List<EventDayInfo> dateList,
  DateTime currentDate,
  void Function() changeToNextMonth,
  void Function() changeToLastMonth,
  void Function(EventDayInfo) goToEventListView,
) {
  int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
  DateTime firstDayOfTheMonth =
      DateTime(currentDate.year, currentDate.month, 1);

  int weekDayOfFirstDay = firstDayOfTheMonth.weekday;

  return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 35,
      itemBuilder: (context, index) {
        if (index < weekDayOfFirstDay - 1) {
          return buildDayInMonth(dateList[index], changeToLastMonth, false);
        } else if (index > weekDayOfFirstDay + daysInMonth - 2) {
          return buildDayInMonth(dateList[index], changeToNextMonth, false);
        } else {
          return buildDayInMonth(
              dateList[index], () => goToEventListView(dateList[index]), true);
        }
      });
}

Widget buildDayInMonth(EventDayInfo day, onPressed, inMonth) {
  bool isToday = CalendarViewModel.isToday(day.date);
  // print(day.date);
  // print(day.hasEvent);
  return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4.0),
            // width: 35,
            decoration: BoxDecoration(
              color: isToday ? Colors.red : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(day.date.day.toString(),
                  style: inMonth
                      ? isToday
                          ? const TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.white)
                          : const TextStyle(
                              fontWeight: FontWeight.w500,
                            )
                      : const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
              height: 4,
              width: 4,
              decoration: BoxDecoration(
                color: day.hasEvent ? Colors.grey : Colors.transparent,
                shape: BoxShape.circle,
              ))
        ],
      ));
}
