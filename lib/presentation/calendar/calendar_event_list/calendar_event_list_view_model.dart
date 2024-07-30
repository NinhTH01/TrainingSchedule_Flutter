import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_schedule/data/local/database/events_database.dart';
import 'package:training_schedule/models/event.dart';

class CalendarEventListViewModel {
  late BuildContext context;

  Future<List<Event>> getEventListOnDate(DateTime currentDate) async {
    var items = <Event>[];

    await EventsDatabase()
        .getListOnDate(currentDate)
        .then(
          (list) => {
            items = list,
          },
        )
        .catchError((error) {
      // Future.error("Error when get Date!!");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Error when get Date!!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return error;
    });

    return items;
  }
}

// Define a provider for the event list
final eventListProvider =
    FutureProvider.family<List<Event>, DateTime>((ref, date) {
  final viewModel = ref.watch(calendarEventListViewModelProvider);
  return viewModel.getEventListOnDate(date);
});

final calendarEventListViewModelProvider =
    Provider<CalendarEventListViewModel>((ref) {
  return CalendarEventListViewModel();
});
