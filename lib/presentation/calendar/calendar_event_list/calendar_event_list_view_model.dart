import '../../../data/local/database/events_database.dart';
import '../../../models/event.dart';

class CalendarEventListViewModel {
  Future<List<Event>> getEventListOnDate(DateTime currentDate) async {
    List<Event> items = [];

    await EventsDatabase()
        .getListOnDate(currentDate)
        .then((list) => {
              items = list,
            })
        .catchError((error) => print(error));

    return items;
  }
}
