import 'package:training_schedule/models/event_day_info.dart';

class CalendarDateInfo {
  final DateTime currentDate;
  final List<EventDayInfo> eventDayInfoList;

  CalendarDateInfo({
    required this.currentDate,
    required this.eventDayInfoList,
  });
}
