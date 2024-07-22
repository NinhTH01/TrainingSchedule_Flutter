import 'package:flutter/material.dart';

import '../../../data/local/database/events_database.dart';
import '../../../models/event.dart';

class CalendarEventListViewModel {
  late BuildContext context;

  Future<List<Event>> getEventListOnDate(DateTime currentDate) async {
    List<Event> items = [];

    await EventsDatabase()
        .getListOnDate(currentDate)
        .then((list) => {
              items = list,
            })
        .catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("Error when capturing map!!"),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });

    return items;
  }
}
