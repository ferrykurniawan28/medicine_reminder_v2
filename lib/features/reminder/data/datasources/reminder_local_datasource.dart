import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/reminder.dart';

class ReminderLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'reminders.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reminders(
            id INTEGER PRIMARY KEY,
            title TEXT,
            dateTime TEXT
          )
        ''');
      },
    );
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final maps = await db.query('reminders');
    return maps
        .map((e) => Reminder(
              id: e['id'] is int
                  ? e['id'] as int
                  : int.tryParse(e['id'].toString()) ?? 0,
              title: e['title'] as String,
              dateTime: DateTime.parse(e['dateTime'] as String),
            ))
        .toList();
  }

  Future<void> addReminder(Reminder reminder) async {
    final db = await database;
    await db.insert(
      'reminders',
      {
        'id': reminder.id,
        'title': reminder.title,
        'dateTime': reminder.dateTime.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteReminder(int id) async {
    final db = await database;
    await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateReminder(Reminder reminder) async {
    final db = await database;
    await db.update(
      'reminders',
      {
        'title': reminder.title,
        'dateTime': reminder.dateTime.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<void> clearReminders() async {
    final db = await database;
    await db.delete('reminders');
  }
}
