import 'dart:async';

import 'package:flutter/material.dart';
import 'package:training_schedule/models/event_day_info.dart';
import 'package:training_schedule/presentation/map/map_view.dart';
import 'package:training_schedule/presentation/weather/weather_view.dart';

import '../calendar/calendar_home/calendar_view.dart';
import '../calendar/calendar_home/calendar_view_model.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  final StreamController<List<EventDayInfo>> _calendarStreamController =
      StreamController<List<EventDayInfo>>();

  int _currentTabBarIndex = 0;

  final CalendarViewModel _calendarViewModel = CalendarViewModel();

  @override
  void initState() {
    super.initState();
    emitCalendarValue();
  }

  void onBottomTap(int newTabIndex) async {
    setState(() {
      _currentTabBarIndex = newTabIndex;
    });

    if (newTabIndex == 0) {
      emitCalendarValue();
    }
  }

  void emitCalendarValue() async {
    List<EventDayInfo> list = [];

    await _calendarViewModel
        .getThisMonthDateList(DateTime.now())
        .then((value) => {list = value});

    _calendarStreamController.sink.add(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _currentTabBarIndex,
          children: [
            CalendarView(
              stream: _calendarStreamController.stream,
            ),
            const MapView(),
            const WeatherView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTabBarIndex,
          onTap: (int newIndex) => {onBottomTap(newIndex)},
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Weather"),
          ],
        ));
  }
}
