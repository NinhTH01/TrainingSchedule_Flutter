import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/presentation/calendar/calendar_home/calendar_view.dart';
import 'package:training_schedule/presentation/calendar/calendar_home/calendar_view_model.dart';
import 'package:training_schedule/presentation/map/map_view.dart';
import 'package:training_schedule/presentation/weather/weather_view.dart';

class NavigationView extends ConsumerWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          CalendarView(
              // Use FutureProvider to get the calendar events
              // stream: ref.watch(calendarEventsProvider.stream),
              ),
          MapView(),
          WeatherView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (newIndex) {
          ref.read(currentTabIndexProvider.notifier).state = newIndex;
          if (newIndex == 0) {
            ref.invalidate(
              calendarStateProvider,
            ); // Refresh the calendar events
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'Weather',
          ),
        ],
      ),
    );
  }
}

// Provider for managing current tab index
final currentTabIndexProvider = StateProvider<int>((ref) => 0);
