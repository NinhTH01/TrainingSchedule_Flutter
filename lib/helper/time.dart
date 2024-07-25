import 'package:intl/intl.dart';

String unixToHH(int unixTime) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

  // Extract the hour
  int hour = dateTime.hour;

  // Format hours as a 2-digit string
  String formattedHour = hour.toString().padLeft(2, '0');

  return formattedHour;
}

String unixToHHmm(int unixTime) {
  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

  // Format DateTime to HH:mm
  final DateFormat formatter = DateFormat('HH:mm');
  return formatter.format(dateTime);
}
