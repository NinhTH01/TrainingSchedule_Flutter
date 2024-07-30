import 'package:intl/intl.dart';

String unixToHH(int unixTime) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

  // Extract the hour
  var hour = dateTime.hour;

  // Format hours as a 2-digit string
  var formattedHour = hour.toString().padLeft(2, '0');

  return formattedHour;
}

String unixToHHmm(int unixTime) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

  // Format DateTime to HH:mm
  final formatter = DateFormat('HH:mm');
  return formatter.format(dateTime);
}
