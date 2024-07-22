import 'package:flutter/material.dart';
import 'package:training_schedule/presentation/map/map_view.dart';
import 'package:training_schedule/presentation/weather/weather_view.dart';

import '../calendar/calendar_home/calendar_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int currentTabBarIndex = 0;

  List<Widget> tabBarItems = const <Widget>[
    CalendarView(),
    MapView(),
    WeatherView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabBarItems.elementAt(currentTabBarIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTabBarIndex,
          onTap: (int newIndex) => {
            setState(() {
              currentTabBarIndex = newIndex;
            })
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: "Calendar"),
            BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Weather"),
          ],
        ));
  }
}
