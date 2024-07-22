import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:training_schedule/models/event_day_info.dart';
import 'package:training_schedule/presentation/calendar/calendar_event_edit/calendar_event_edit_view.dart';
import 'package:training_schedule/presentation/calendar/calendar_event_list/calendar_event_list_view_model.dart';

import '../../../models/event.dart';
import '../components/calendar_detail_header.dart';

class CalendarEventListView extends StatefulWidget {
  final EventDayInfo date;

  const CalendarEventListView({super.key, required this.date});

  @override
  State<CalendarEventListView> createState() => _CalendarEventListViewState();
}

class _CalendarEventListViewState extends State<CalendarEventListView> {
  final CalendarEventListViewModel _viewModel = CalendarEventListViewModel();

  List<Event> _eventList = [];

  @override
  void initState() {
    super.initState();
    _getEventList();
    _viewModel.context = context;
  }

  void _getEventList() {
    _viewModel.getEventListOnDate(widget.date.date).then((eventList) {
      setState(() {
        _eventList = eventList;
      });
    });
  }

  void _goToEventEditView(bool isEdit, Event? event) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CalendarEventEditView(
                  date: widget.date,
                  isEdit: isEdit,
                  event: event,
                ))).then((_) {
      _getEventList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        calendarDetailHeader(context, widget, _goToEventEditView),
        Expanded(
            child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return eventItemList(_eventList[index], _goToEventEditView);
          },
          itemCount: _eventList.length,
        ))
      ],
    )));
  }
}

Widget eventItemList(Event event, void Function(bool, Event) onTap) {
  String timeInHHmm = DateFormat('HH:mm').format(event.createdTime);
  return GestureDetector(
    child: Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: Colors.black),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(timeInHHmm,
              style:
                  const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
          Text(
            event.description,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
    onTap: () {
      onTap(true, event);
    },
  );
}
