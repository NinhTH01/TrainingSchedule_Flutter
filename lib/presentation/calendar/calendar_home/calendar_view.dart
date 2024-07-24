import 'dart:async';

import 'package:flutter/material.dart';
import 'package:training_schedule/models/event_day_info.dart';
import 'package:training_schedule/presentation/calendar/calendar_event_list/calendar_event_list_view.dart';
import 'package:training_schedule/presentation/calendar/components/build_header.dart';
import 'package:training_schedule/presentation/calendar/components/build_week.dart';

import '../components/build_calendar.dart';
import 'calendar_view_model.dart';

class CalendarView extends StatefulWidget {
  final Stream<List<EventDayInfo>> stream;

  const CalendarView({super.key, required this.stream});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class _CalendarViewState extends State<CalendarView> {
  // Var and const
  late StreamSubscription<List<EventDayInfo>> _subscription;

  final CalendarViewModel _viewModel = CalendarViewModel();

  DateTime _currentDate = DateTime.now();

  List<EventDayInfo> _dateList = [];

  // Life Cycle
  @override
  void initState() {
    super.initState();
    _viewModel.context = context;

    _subscription = widget.stream.listen((value) {
      setState(() {
        _dateList = value;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // Function
  void _changeToLastMonth() {
    _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    _getCalculatedDateList();
  }

  void _changeToNextMonth() {
    _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    _getCalculatedDateList();
  }

  void _getCalculatedDateList() {
    _viewModel.getThisMonthDateList(_currentDate).then((list) => {
          if (list.isNotEmpty)
            {
              setState(() {
                _dateList = list;
              }),
            }
        });
  }

  void _goToEventListView(EventDayInfo date) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CalendarEventListView(date: date))).then((_) {
      _getCalculatedDateList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          buildHeader(_currentDate, _changeToNextMonth, _changeToLastMonth),
          buildWeek(),
          const SizedBox(height: 24),
          _dateList.isNotEmpty
              ? Expanded(
                  child: buildCalendar(
                      _dateList,
                      _currentDate,
                      _changeToNextMonth,
                      _changeToLastMonth,
                      _goToEventListView),
                )
              : const CircularProgressIndicator()
        ],
      )),
    );
  }
}
