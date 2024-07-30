import 'package:intl/intl.dart';

const String tableEvents = 'events';

class EventFields {
  static final List<String> values = [id, description, distance, time];

  static const String id = '_id';
  static const String distance = 'distance';
  static const String description = 'description';
  static const String time = 'time';
}

class Event {
  final int? id;
  final String description;
  final double distance;
  final DateTime createdTime;

  const Event({
    this.id,
    required this.distance,
    required this.description,
    required this.createdTime,
  });

  Map<String, Object?> toMap() {
    return {
      EventFields.id: id,
      EventFields.distance: distance,
      EventFields.description: description,
      EventFields.time: DateFormat('yyyy-MM-dd HH:mm:ss').format(createdTime),
    };
  }

  static Event fromJson(Map<String, Object?> json) => Event(
        id: json[EventFields.id] as int?,
        distance: json[EventFields.distance] as double,
        description: json[EventFields.description] as String,
        createdTime: DateTime.parse(json[EventFields.time] as String),
      );

  Event copy({
    int? id,
    String? description,
    DateTime? createdTime,
    double? distance,
  }) =>
      Event(
        id: id ?? this.id,
        description: description ?? this.description,
        createdTime: createdTime ?? this.createdTime,
        distance: distance ?? this.distance,
      );
}
