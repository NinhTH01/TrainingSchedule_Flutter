import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:training_schedule/models/event_day_info.dart';
import 'package:training_schedule/presentation/calendar/calendar_event_edit/calendar_event_edit_model_view.dart';

import '../../../models/event.dart';

class CalendarEventEditView extends StatefulWidget {
  final EventDayInfo date;
  final bool isEdit;
  final Event? event;
  const CalendarEventEditView(
      {super.key, required this.date, required this.isEdit, this.event});

  @override
  State<CalendarEventEditView> createState() => _CalendarEventEditViewState();
}

class _CalendarEventEditViewState extends State<CalendarEventEditView> {
  final CalendarEventEditModelView _modelView = CalendarEventEditModelView();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _modelView.selectedTime =
          TimeOfDay.fromDateTime(widget.event!.createdTime);
      _modelView.controller.text = widget.event!.description;
    }
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Delete Event'),
        message: const Text('Are you sure you want to proceed?'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              _modelView.deleteEvent(widget, context);
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              Text(
                widget.isEdit ? "Edit Event" : "New Event",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextButton(
                  onPressed: () {
                    _modelView.addOrUpdateEvent(widget);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ))
            ],
          ),
          Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _modelView.controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () async {
                        final TimeOfDay? timeOfDay = await showTimePicker(
                          context: context,
                          initialTime: _modelView.selectedTime,
                          initialEntryMode: TimePickerEntryMode.input,
                        );
                        if (timeOfDay != null) {
                          setState(() {
                            _modelView.selectedTime = timeOfDay;
                          });
                        }
                      },
                      child: Text(
                        _modelView.selectedTime.format(context),
                        style: const TextStyle(color: Colors.black),
                      ))
                ],
              )),
          const SizedBox(height: 40),
          widget.isEdit
              ? TextButton(
                  onPressed: () {
                    _showActionSheet(context);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ))
              : const SizedBox(),
        ],
      )),
    );
  }
}
