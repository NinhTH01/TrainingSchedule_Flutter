import 'package:training_schedule/models/event_day_info.dart';

class CalendarState {
  final DateTime currentDate;
  final List<EventDayInfo> dateList;

  CalendarState({
    required this.currentDate,
    required this.dateList,
  });
}
