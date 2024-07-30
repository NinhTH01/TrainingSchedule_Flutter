import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../calendar_event_list/calendar_event_list_view.dart';
import '../components/build_calendar.dart';
import '../components/build_header.dart';
import '../components/build_week.dart';
import 'calendar_view_model.dart';

class CalendarView extends ConsumerWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarStateProvider);
    final dateList = calendarState.dateList;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(
              calendarState.currentDate,
              () =>
                  ref.read(calendarStateProvider.notifier).changeToNextMonth(),
              () =>
                  ref.read(calendarStateProvider.notifier).changeToLastMonth(),
            ),
            buildWeek(),
            const SizedBox(height: 24),
            dateList.isNotEmpty
                ? Expanded(
                    child: buildCalendar(
                      dateList,
                      calendarState.currentDate,
                      () => ref
                          .read(calendarStateProvider.notifier)
                          .changeToNextMonth(),
                      () => ref
                          .read(calendarStateProvider.notifier)
                          .changeToLastMonth(),
                      (date) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CalendarEventListView(date: date),
                          ),
                        ).then((_) {
                          ref
                              .read(calendarStateProvider.notifier)
                              .fetchAndUpdateDateList(
                                  calendarState.currentDate);
                        });
                      },
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
