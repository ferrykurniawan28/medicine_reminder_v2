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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE appointments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            userName TEXT,
            userRole INTEGER,
            doctorId INTEGER,
            doctorName TEXT,
            doctorSpeciality TEXT,
            note TEXT,
            time TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    final db = await database;
    final maps = await db.query('appointments');
    return maps.map((e) => AppointmentModel.fromJson(_fromDbMap(e))).toList();
  }

  @override
  Future<AppointmentModel?> getAppointment(int id) async {
    final db = await database;
    final maps =
        await db.query('appointments', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return AppointmentModel.fromJson(_fromDbMap(maps.first));
  }

  @override
  Future<void> addAppointment(AppointmentModel appointment) async {
    final db = await database;
    final data = _toDbMap(appointment);
    // Remove id if null so SQLite auto-increments
    if (data['id'] == null) {
      data.remove('id');
    }
    await db.insert('appointments', data);
  }

  @override
  Future<void> updateAppointment(AppointmentModel appointment) async {
    final db = await database;
    await db.update('appointments', _toDbMap(appointment),
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

  Map<String, dynamic> _toDbMap(AppointmentModel appointment) => {
        'id': appointment.id,
        'userId': appointment.user.userId,
        'userName': appointment.user.userName,
        'userRole': appointment.user.role?.index,
        'doctorId': appointment.doctor.id,
        'doctorName': appointment.doctor.name,
        'doctorSpeciality': appointment.doctor.speciality,
        'note': appointment.note,
        'time': appointment.time.toIso8601String(),
      };

  Map<String, dynamic> _fromDbMap(Map<String, dynamic> map) => {
        'id': map['id'] == null
            ? null
            : (map['id'] is int
                ? map['id']
                : int.tryParse(map['id'].toString())),
        'user': {
          'userId': map['userId'] == null
              ? 0
              : (map['userId'] is int
                  ? map['userId']
                  : int.tryParse(map['userId'].toString()) ?? 0),
          'userName': map['userName'] ?? '',
          'role': map['userRole'],
        },
        'doctor': {
          'id': map['doctorId'],
          'name': map['doctorName'],
          'speciality': map['doctorSpeciality'],
        },
        'note': map['note'],
        'time': map['time'],
      };
}
