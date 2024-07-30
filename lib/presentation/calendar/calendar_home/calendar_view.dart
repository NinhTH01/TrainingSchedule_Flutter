import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/presentation/calendar/calendar_event_list/calendar_event_list_view.dart';
import 'package:training_schedule/presentation/calendar/calendar_home/calendar_view_model.dart';
import 'package:training_schedule/presentation/calendar/components/build_calendar.dart';
import 'package:training_schedule/presentation/calendar/components/build_header.dart';
import 'package:training_schedule/presentation/calendar/components/build_week.dart';

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
                                calendarState.currentDate,
                              );
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
