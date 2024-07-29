import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/models/event_day_info.dart';
import 'package:training_schedule/presentation/calendar/calendar_home/calendar_view_model.dart';

// Calendar ViewModel Provider
final calendarViewModelProvider = Provider<CalendarViewModel>((ref) {
  return CalendarViewModel();
});

// Calendar Events Stream Provider
final calendarEventsProvider = StreamProvider<List<EventDayInfo>>((ref) {
  final calendarViewModel = ref.read(calendarViewModelProvider);
  return calendarViewModel.getThisMonthDateListStream(DateTime.now());
});
