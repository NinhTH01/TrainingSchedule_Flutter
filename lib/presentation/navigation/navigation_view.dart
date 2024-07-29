import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/presentation/map/map_view.dart';
import 'package:training_schedule/presentation/weather/weather_view.dart';

import '../calendar/calendar_home/calendar_view.dart';
import 'navigation_view_model.dart'; // Import the file where you defined the providers

class NavigationView extends ConsumerWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          CalendarView(
            // Use FutureProvider to get the calendar events
            stream: ref.watch(calendarEventsProvider.stream),
          ),
          const MapView(),
          const WeatherView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (newIndex) {
          ref.read(currentTabIndexProvider.notifier).state = newIndex;
          if (newIndex == 0) {
            ref.refresh(calendarEventsProvider); // Refresh the calendar events
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: "Weather",
          ),
        ],
      ),
    );
  }
}

// Provider for managing current tab index
final currentTabIndexProvider = StateProvider<int>((ref) => 0);
