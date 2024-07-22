import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/event.dart';

class EventsDatabase {
  static const _databaseName = "events.db";
  static const _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const notNullTextType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableEvents ( 
        ${EventFields.id} $idType, 
        ${EventFields.description} $textType,
        ${EventFields.distance} $doubleType,
        ${EventFields.time} $notNullTextType
      )
 ''');
  }

  Future<void> insert(Event event) async {
    final db = await database;

    await db.insert(
      tableEvents,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Event event) async {
    final db = await database;

    await db.update(
      tableEvents,
      event.toMap(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<void> delete(int? eventId) async {
    final db = await database;

    await db.delete(
      tableEvents,
      where: '${EventFields.id} = ?',
      whereArgs: [eventId],
    );
  }

  Future<List<Event>> getList() async {
    // Get a reference to the database.
    final db = await database;

    const orderBy = '${EventFields.time} ASC';
    // Query the table for all the dogs.
    final List<Map<String, Object?>> result =
        await db.query(tableEvents, orderBy: orderBy);

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return result.map((json) => Event.fromJson(json)).toList();
  }

  Future<List<Event>> getListOnDate(DateTime date) async {
    // Get a reference to the database.
    final db = await database;
    const orderBy = '${EventFields.time} ASC';

    DateTime startDate = DateTime(date.year, date.month, date.day);
    DateTime endDate =
        DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    // Format the date range
    String formattedStartDate =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(startDate);
    String formattedEndDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(endDate);

    // Query the table for all the dogs.
    final List<Map<String, Object?>> result = await db.query(tableEvents,
        where: 'time BETWEEN ? AND ?',
        whereArgs: [formattedStartDate, formattedEndDate],
        orderBy: orderBy);

    // Convert the list of each dog's fields into a list of `Dog` objects.
    return result.map((json) => Event.fromJson(json)).toList();
  }
}
