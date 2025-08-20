import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medical_record_model.dart';
import 'medical_record_local_datasource.dart';

class MedicalRecordLocalDataSourceImpl implements MedicalRecordLocalDataSource {
  static Database? _database;
  static const String _tableName = 'medical_records';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medical_records.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY,
        type TEXT NOT NULL,
        log_time TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        assigned_to INTEGER NOT NULL,
        created_by TEXT NOT NULL,
        created_at TEXT NOT NULL,
        medicine_name TEXT,
        dosage INTEGER,
        time TEXT,
        device_id INTEGER,
        container_id INTEGER,
        doctor TEXT,
        appointment_date TEXT
      )
    ''');
  }

  @override
  Future<List<MedicalRecordModel>> getMedicalRecords({
    int? userId,
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final db = await database;

      String whereClause = '';
      List<dynamic> whereArgs = [];

      if (userId != null) {
        whereClause = 'assigned_to = ?';
        whereArgs.add(userId);
      }

      if (type != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'type = ?';
        whereArgs.add(type);
      }

      if (status != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'status = ?';
        whereArgs.add(status);
      }

      if (startDate != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'log_time >= ?';
        whereArgs.add(startDate.toIso8601String());
      }

      if (endDate != null) {
        if (whereClause.isNotEmpty) whereClause += ' AND ';
        whereClause += 'log_time <= ?';
        whereArgs.add(endDate.toIso8601String());
      }

      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: whereClause.isNotEmpty ? whereClause : null,
        whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
        orderBy: 'log_time DESC',
      );

      print('Loaded ${maps.length} medical records from local database');

      return maps.map((map) {
        return MedicalRecordModel.fromJson(map) as MedicalRecordModel;
      }).toList();
    } catch (e) {
      print('Error loading medical records from local database: $e');
      return [];
    }
  }

  @override
  Future<MedicalRecordModel?> getMedicalRecord(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isNotEmpty) {
        return MedicalRecordModel.fromJson(maps.first) as MedicalRecordModel;
      }
      return null;
    } catch (e) {
      print('Error loading medical record from local database: $e');
      return null;
    }
  }

  @override
  Future<void> addMedicalRecord(MedicalRecordModel record) async {
    try {
      final db = await database;
      await db.insert(
        _tableName,
        _recordToMap(record),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Saved medical record to local database');
    } catch (e) {
      print('Error saving medical record to local database: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateMedicalRecord(MedicalRecordModel record) async {
    try {
      final db = await database;
      final int recordId;
      if (record is ReminderRecordModel) {
        recordId = record.id;
      } else if (record is AppointmentRecordModel) {
        recordId = record.id;
      } else {
        throw Exception('Unknown record type');
      }

      await db.update(
        _tableName,
        _recordToMap(record),
        where: 'id = ?',
        whereArgs: [recordId],
      );
      print('Updated medical record in local database');
    } catch (e) {
      print('Error updating medical record in local database: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteMedicalRecord(int id) async {
    try {
      final db = await database;
      await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Deleted medical record from local database');
    } catch (e) {
      print('Error deleting medical record from local database: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAllMedicalRecords() async {
    try {
      final db = await database;
      await db.delete(_tableName);
      print('Deleted all medical records from local database');
    } catch (e) {
      print('Error deleting all medical records from local database: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _recordToMap(MedicalRecordModel record) {
    final map = record.toJson();
    // Convert DateTime objects to ISO strings for database storage
    if (map['log_time'] is DateTime) {
      map['log_time'] = (map['log_time'] as DateTime).toIso8601String();
    }
    if (map['created_at'] is DateTime) {
      map['created_at'] = (map['created_at'] as DateTime).toIso8601String();
    }
    if (map['appointment_date'] is DateTime) {
      map['appointment_date'] =
          (map['appointment_date'] as DateTime).toIso8601String();
    }
    return map;
  }
}
