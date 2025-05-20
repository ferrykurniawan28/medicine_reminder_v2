import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/time.dart';
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
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reminders(
            id INTEGER PRIMARY KEY,
            deviceId INTEGER,
            userId INTEGER,
            containerId INTEGER,
            medicineName TEXT,
            dosage TEXT,
            medicineLeft INTEGER,
            isActive INTEGER,
            isAlert INTEGER,
            note TEXT,
            type INTEGER,
            times TEXT,
            daysofWeek TEXT,
            endDate TEXT
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
              id: e['id'] != null && e['id'].toString().isNotEmpty
                  ? (e['id'] is int
                      ? e['id'] as int
                      : int.tryParse(e['id'].toString()))
                  : null,
              deviceId:
                  e['deviceId'] != null && e['deviceId'].toString().isNotEmpty
                      ? (e['deviceId'] is int
                          ? e['deviceId'] as int
                          : int.tryParse(e['deviceId'].toString()))
                      : null,
              userId: e['userId'] != null && e['userId'].toString().isNotEmpty
                  ? (e['userId'] is int
                      ? e['userId'] as int
                      : int.tryParse(e['userId'].toString()))
                  : null,
              containerId: e['containerId'] != null &&
                      e['containerId'].toString().isNotEmpty
                  ? (e['containerId'] is int
                      ? e['containerId'] as int
                      : int.tryParse(e['containerId'].toString()))
                  : null,
              medicineName: (e['medicineName'] ?? '') as String,
              dosage:
                  (e['dosage'] is String && (e['dosage'] as String).isNotEmpty)
                      ? (e['dosage'] as String)
                          .split(',')
                          .where((v) => v.isNotEmpty)
                          .map((v) => int.tryParse(v) ?? 0)
                          .toList()
                      : <int>[],
              medicineLeft: e['medicineLeft'] != null &&
                      e['medicineLeft'].toString().isNotEmpty
                  ? (e['medicineLeft'] is int
                      ? e['medicineLeft'] as int
                      : int.tryParse(e['medicineLeft'].toString()))
                  : null,
              isActive: (e['isActive'] is int
                      ? e['isActive']
                      : int.tryParse(e['isActive']?.toString() ?? '')) ==
                  1,
              isAlert: (e['isAlert'] is int
                      ? e['isAlert']
                      : int.tryParse(e['isAlert']?.toString() ?? '')) ==
                  1,
              note: e['note'] as String?,
              type: ReminderType.values[e['type'] is int
                  ? e['type'] as int
                  : int.tryParse(e['type']?.toString() ?? '0') ?? 0],
              times: (e['times'] is String && (e['times'] as String).isNotEmpty)
                  ? (e['times'] as String)
                      .split(';')
                      .where((s) => s.isNotEmpty)
                      .map((v) => Time.fromString(v))
                      .toList()
                  : <Time>[],
              daysofWeek: e['daysofWeek'] != null &&
                      (e['daysofWeek'] as String).isNotEmpty
                  ? (e['daysofWeek'] as String)
                      .split(',')
                      .map((v) => Days.values[int.parse(v)])
                      .toList()
                  : null,
              endDate:
                  e['endDate'] != null && (e['endDate'] as String).isNotEmpty
                      ? DateTime.tryParse(e['endDate'] as String)
                      : null,
            ))
        .toList();
  }

  Future<Reminder> addReminder(Reminder reminder) async {
    final db = await database;
    // Remove id if null to let SQLite autoincrement
    final data = {
      'deviceId': reminder.deviceId,
      'userId': reminder.userId,
      'containerId': reminder.containerId,
      'medicineName': reminder.medicineName,
      'dosage': reminder.dosage.join(','),
      'medicineLeft': reminder.medicineLeft,
      'isActive': reminder.isActive ? 1 : 0,
      'isAlert': reminder.isAlert ? 1 : 0,
      'note': reminder.note,
      'type': reminder.type.index,
      'times': reminder.times.map((t) => t.toString()).join(';'),
      'daysofWeek': reminder.daysofWeek?.map((d) => d.index).join(','),
      'endDate': reminder.endDate?.toIso8601String(),
    };
    final id = await db.insert(
      'reminders',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Return the reminder with the new id
    return reminder.copyWith(id: id);
  }

  Future<void> updateReminder(Reminder reminder) async {
    final db = await database;
    await db.update(
      'reminders',
      {
        'deviceId': reminder.deviceId,
        'userId': reminder.userId,
        'containerId': reminder.containerId,
        'medicineName': reminder.medicineName,
        'dosage': reminder.dosage.join(','),
        'medicineLeft': reminder.medicineLeft,
        'isActive': reminder.isActive ? 1 : 0,
        'isAlert': reminder.isAlert ? 1 : 0,
        'note': reminder.note,
        'type': reminder.type.index,
        'times': reminder.times.map((t) => t.toString()).join(';'),
        'daysofWeek': reminder.daysofWeek?.map((d) => d.index).join(','),
        'endDate': reminder.endDate?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<void> deleteReminder(int id) async {
    final db = await database;
    await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearReminders() async {
    final db = await database;
    await db.delete('reminders');
  }
}
