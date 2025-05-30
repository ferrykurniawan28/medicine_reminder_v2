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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE appointments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_by INTEGER,
            assigned_to INTEGER,
            doctor TEXT,
            notes TEXT,
            dates TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    final db = await database;
    final maps = await db.query('appointments');
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
    await db.insert('appointments', data);
  }

  @override
  Future<void> updateAppointment(AppointmentModel appointment) async {
    final db = await database;
    await db.update('appointments', appointment.toJson(),
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
}
