import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/appointment_model.dart';
import 'appointment_local_datasource.dart';

class AppointmentLocalDataSourceImpl implements AppointmentLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'appointments.db');
    return await openDatabase(
      path,
      version: 4, // Bump version for migration
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE appointments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_by INTEGER,
            assigned_to INTEGER,
            doctor TEXT,
            notes TEXT,
            dates TEXT,
            is_synced INTEGER DEFAULT 0,
            is_deleted INTEGER DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 4) {
          await db.execute(
              'ALTER TABLE appointments ADD COLUMN is_deleted INTEGER DEFAULT 0');
        }
      },
    );
  }

  @override
  Future<List<AppointmentModel>> getAppointments(int userId) async {
    final db = await database;
    final maps = await db.query(
      'appointments',
      where: 'assigned_to = ? AND is_deleted = 0',
      whereArgs: [userId],
    );
    return maps
        .map((e) => AppointmentModel.fromJson({
              ...e,
              'userCreated': e['created_by'],
              'userAssigned': e['assigned_to'],
              'doctor': e['doctor'],
              'note': e['notes'],
              'time': e['dates'],
            }))
        .toList();
  }

  @override
  Future<AppointmentModel?> getAppointment(int id) async {
    final db = await database;
    final maps =
        await db.query('appointments', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final e = maps.first;
    return AppointmentModel.fromJson({
      ...e,
      'userCreated': e['created_by'],
      'userAssigned': e['assigned_to'],
      'doctor': e['doctor'],
      'note': e['notes'],
      'time': e['dates'],
    });
  }

  @override
  Future<void> addAppointment(AppointmentModel appointment) async {
    final db = await database;
    final data = appointment.toJson();
    // Remove id if null so SQLite auto-increments
    if (data['id'] == null) {
      data.remove('id');
    }
    data['is_synced'] = 0; // Always mark as not synced on local add
    await db.insert('appointments', data);
  }

  @override
  Future<void> updateAppointment(AppointmentModel appointment) async {
    final db = await database;
    final data = appointment.toJson();
    data['is_synced'] = 0; // Always mark as not synced on local update
    await db.update('appointments', data,
        where: 'id = ?', whereArgs: [appointment.id]);
  }

  @override
  Future<void> deleteAppointment(int id) async {
    final db = await database;
    await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllAppointments() async {
    final db = await database;
    await db.delete('appointments');
  }

  @override
  Future<void> markAppointmentAsDeleted(int id) async {
    final db = await database;
    await db.update(
      'appointments',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<AppointmentModel>> getDeletedAppointments() async {
    final db = await database;
    final maps = await db.query(
      'appointments',
      where: 'is_deleted = 1',
    );
    return maps
        .map((e) => AppointmentModel.fromJson({
              ...e,
              'userCreated': e['created_by'],
              'userAssigned': e['assigned_to'],
              'doctor': e['doctor'],
              'note': e['notes'],
              'time': e['dates'],
            }))
        .toList();
  }

  @override
  Future<void> markAppointmentAsSynced(int id) async {
    final db = await database;
    await db.update(
      'appointments',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markAppointmentNotSynced(int id) async {
    final db = await database;
    await db.update(
      'appointments',
      {'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<AppointmentModel>> getUnsyncedAppointments() async {
    final db = await database;
    final maps = await db.query(
      'appointments',
      where: 'is_synced = 0 AND is_deleted = 0',
    );
    return maps
        .map((e) => AppointmentModel.fromJson({
              ...e,
              'userCreated': e['created_by'],
              'userAssigned': e['assigned_to'],
              'doctor': e['doctor'],
              'note': e['notes'],
              'time': e['dates'],
            }))
        .toList();
  }
}
