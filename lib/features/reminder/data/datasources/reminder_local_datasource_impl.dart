import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/entities/reminder.dart';
import 'reminder_local_datasource_interface.dart';
import 'package:medicine_reminder/features/reminder/domain/entities/time.dart';
import 'package:medicine_reminder/features/user/domain/entities/user.dart';

//TODO: fix users table attachment
class ReminderLocalDataSourceImpl implements ReminderLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'reminders.db');
    final usersDbPath = join(dbPath, 'users.db');

    final db = await openDatabase(
      path,
      version: 6, // Bump version for migration
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reminders(
            id INTEGER PRIMARY KEY,
            deviceId INTEGER,
            createdBy INTEGER,
            assignedTo INTEGER,
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
            endDate TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 6) {
          await db
              .execute('ALTER TABLE reminders ADD COLUMN createdBy INTEGER');
          await db
              .execute('ALTER TABLE reminders ADD COLUMN assignedTo INTEGER');
        }
        if (oldVersion < 5) {
          await db.execute(
              'ALTER TABLE reminders ADD COLUMN is_synced INTEGER DEFAULT 0');
        }
      },
    );

    // Attach the users database
    try {
      await db.execute("ATTACH DATABASE '$usersDbPath' AS users_db");
      print('[ReminderLocalDataSourceImpl] Successfully attached users_db.');

      await db.execute('''
          CREATE TABLE IF NOT EXISTS users_db.users (
            id INTEGER PRIMARY KEY,
            username TEXT,
            email TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');
      print(
          '[ReminderLocalDataSourceImpl] Verified or created users table in users_db.');

      // Verify the users table exists
      final result = await db.rawQuery(
          "SELECT name FROM users_db.sqlite_master WHERE type='table' AND name='users'");
      if (result.isEmpty) {
        throw Exception(
            "Users table not found in users_db after creation attempt.");
      }
    } catch (e) {
      print(
          '[ReminderLocalDataSourceImpl] Error attaching or creating users_db: $e');
    }

    return db;
  }

  @override
  Future<List<Reminder>> getReminders(int userId) async {
    final db = await database;
    final dbPath = await getDatabasesPath();
    final deviceDbPath = join(dbPath, 'device.db');
    final usersDbPath = join(dbPath, 'users.db');

    // Check if device_db is already attached
    final attachedDbs = await db.rawQuery("PRAGMA database_list;");
    final isDeviceDbAttached =
        attachedDbs.any((row) => row['name'] == 'device_db');
    final isUsersDbAttached =
        attachedDbs.any((row) => row['name'] == 'users_db');

    if (!isDeviceDbAttached) {
      try {
        await db.execute("ATTACH DATABASE '$deviceDbPath' AS device_db");
      } catch (e) {
        print('[ReminderLocalDataSourceImpl] Error attaching device_db: $e');
      }
    }

    if (!isUsersDbAttached) {
      try {
        await db.execute("ATTACH DATABASE '$usersDbPath' AS users_db");
      } catch (e) {
        print('[ReminderLocalDataSourceImpl] Error attaching users_db: $e');
      }
    }

    List<Map<String, Object?>> result = [];
    try {
      result = await db.rawQuery('''
            SELECT r.*, 
                   c.medicine_name as container_medicine_name, 
                   c.quantity as container_quantity,
                   u1.username as createdByName, u1.email as createdByEmail,
                   u2.username as assignedToName, u2.email as assignedToEmail
            FROM reminders r
            LEFT JOIN device_db.containers c
              ON r.deviceId = c.device_id AND r.containerId = c.container_id
            LEFT JOIN users_db.users u1
              ON r.createdBy = u1.id
            LEFT JOIN users_db.users u2
              ON r.assignedTo = u2.id
            WHERE r.assignedTo = ?
            ORDER BY r.id DESC
        ''', [userId]);
    } catch (e) {
      print(
          '[ReminderLocalDataSourceImpl] Fallback: users_db.users or device_db.containers missing, using reminders only. Error: $e');
      result = await db.query('reminders',
          where: 'assignedTo = ?', whereArgs: [userId], orderBy: 'id DESC');
    }

    if (!isDeviceDbAttached) {
      try {
        await db.execute("DETACH DATABASE device_db");
      } catch (e) {
        print('[ReminderLocalDataSourceImpl] Error detaching device_db: $e');
      }
    }

    if (!isUsersDbAttached) {
      try {
        await db.execute("DETACH DATABASE users_db");
      } catch (e) {
        print('[ReminderLocalDataSourceImpl] Error detaching users_db: $e');
      }
    }

    return result
        .map((e) => Reminder(
              id: e['id'] as int?,
              deviceId: e['deviceId'] as int?,
              createdBy: e['createdBy'] != null
                  ? User(
                      userId: e['createdBy'] as int,
                      userName: e['createdByName'] as String?,
                      email: e['createdByEmail'] as String?)
                  : null,
              assignedTo: e['assignedTo'] != null
                  ? User(
                      userId: e['assignedTo'] as int,
                      userName: e['assignedToName'] as String?,
                      email: e['assignedToEmail'] as String?)
                  : null,
              containerId: e['containerId'] as int?,
              medicineName:
                  (e['container_medicine_name'] ?? e['medicineName']) as String,
              dosage: (e['dosage'] as String?)
                      ?.split(',')
                      .map((v) => int.tryParse(v) ?? 0)
                      .toList() ??
                  [],
              medicineLeft: e['quantity'] as int? ?? e['medicineLeft'] as int?,
              isActive: (e['isActive'] as int) == 1,
              isAlert: (e['isAlert'] as int) == 1,
              note: e['note'] as String?,
              type: ReminderType.values[e['type'] as int],
              times: (e['times'] as String?)
                      ?.split(';')
                      .map((v) => Time.fromString(v))
                      .toList() ??
                  [],
              daysofWeek: (e['daysofWeek'] as String?)
                  ?.split(',')
                  .map((v) => Days.values[int.parse(v)])
                  .toList(),
              endDate: e['endDate'] != null && e['endDate'] is String
                  ? DateTime.tryParse(e['endDate'] as String)
                  : null,
            ))
        .toList();
  }

  @override
  Future<Reminder> addReminder(Reminder reminder,
      {bool isSynced = false}) async {
    int synced = isSynced ? 1 : 0; // Determine sync status
    final db = await database;

    // Ensure `createdBy` user exists in the `users` table
    if (reminder.createdBy != null) {
      try {
        await db.insert(
          'users_db.users',
          {
            'id': reminder.createdBy!.userId,
            'username': reminder.createdBy!.userName,
            'email': reminder.createdBy!.email,
          },
          conflictAlgorithm:
              ConflictAlgorithm.replace, // Ignore if user already exists
        );
      } catch (e) {
        print(
            '[ReminderLocalDataSourceImpl] Error inserting createdBy user: $e');
      }
    }

    // Ensure `assignedTo` user exists in the `users` table
    if (reminder.assignedTo != null) {
      try {
        await db.insert(
          'users_db.users',
          {
            'id': reminder.assignedTo!.userId,
            'username': reminder.assignedTo!.userName,
            'email': reminder.assignedTo!.email,
          },
          conflictAlgorithm:
              ConflictAlgorithm.ignore, // Ignore if user already exists
        );
      } catch (e) {
        print(
            '[ReminderLocalDataSourceImpl] Error inserting assignedTo user: $e');
      }
    }

    // Insert the reminder into the `reminders` table
    final data = {
      'id': reminder.id ?? null, // Use null for auto-increment
      'deviceId': reminder.deviceId,
      'createdBy': reminder.createdBy?.userId,
      'assignedTo': reminder.assignedTo?.userId,
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
      'is_synced': synced,
    };
    final id = await db.insert(
      'reminders',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return reminder.copyWith(id: id);
  }

  @override
  Future<void> updateReminder(Reminder reminder,
      {bool isSynced = false}) async {
    final db = await database;
    await db.update(
      'reminders',
      reminder.toJson()..['is_synced'] = isSynced ? 1 : 0,
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  @override
  Future<void> updateReminderStatus(Reminder reminder,
      {bool isSynced = false}) async {
    final db = await database;
    await db.update(
      'reminders',
      {
        'isActive': reminder.isActive ? 1 : 0,
        'is_synced': isSynced ? 1 : 0, // Update sync status
      },
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  @override
  Future<void> deleteReminder(int id) async {
    final db = await database;
    await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> clearReminders() async {
    final db = await database;
    await db.delete('reminders');
  }

  @override
  Future<List<Reminder>?> getUnsyncedReminders(int userId) async {
    final db = await database;
    List<Map<String, Object?>> result = [];
    try {
      result = await db.rawQuery('''
            SELECT r.*, 
                   u1.username as createdByName, u1.email as createdByEmail,
                   u2.username as assignedToName, u2.email as assignedToEmail
            FROM reminders r
            LEFT JOIN users_db.users u1
              ON r.createdBy = u1.id
            LEFT JOIN users_db.users u2
              ON r.assignedTo = u2.id
            WHERE r.is_synced = 0 AND r.assignedTo = ?
            ORDER BY r.id DESC
        ''', [userId]);
    } catch (e) {
      print(
          '[ReminderLocalDataSourceImpl] Error fetching unsynced reminders: $e');
      result = await db.query(
        'reminders',
        where: 'is_synced = 0 AND assignedTo = ?',
        whereArgs: [userId],
        orderBy: 'id DESC',
      );
    }

    if (result.isEmpty) return null;

    return result
        .map((e) => Reminder(
              id: e['id'] as int?,
              deviceId: e['deviceId'] as int?,
              createdBy: e['createdBy'] != null
                  ? User(
                      userId: e['createdBy'] as int,
                      userName: e['createdByName'] as String?,
                      email: e['createdByEmail'] as String?)
                  : null,
              assignedTo: e['assignedTo'] != null
                  ? User(
                      userId: e['assignedTo'] as int,
                      userName: e['assignedToName'] as String?,
                      email: e['assignedToEmail'] as String?)
                  : null,
              containerId: e['containerId'] as int?,
              medicineName: e['medicineName'] as String,
              dosage: (e['dosage'] as String?)
                      ?.split(',')
                      .map((v) => int.tryParse(v) ?? 0)
                      .toList() ??
                  [],
              medicineLeft: e['medicineLeft'] as int?,
              isActive: (e['isActive'] as int) == 1,
              isAlert: (e['isAlert'] as int) == 1,
              note: e['note'] as String?,
              type: ReminderType.values[e['type'] as int],
              times: (e['times'] as String?)
                      ?.split(';')
                      .map((v) => Time.fromString(v))
                      .toList() ??
                  [],
              daysofWeek: (e['daysofWeek'] as String?)
                  ?.split(',')
                  .map((v) => Days.values[int.parse(v)])
                  .toList(),
              endDate: e['endDate'] != null && e['endDate'] is String
                  ? DateTime.tryParse(e['endDate'] as String)
                  : null,
            ))
        .toList();
  }

  @override
  Future<void> markReminderAsSynced(int reminderId) async {
    final db = await database;
    await db.update(
      'reminders',
      {'is_synced': 1}, // Mark as synced
      where: 'id = ?',
      whereArgs: [reminderId],
    );
  }

  @override
  Future<void> markReminderAsDeleted(int reminderId) async {
    final db = await database;
    await db.update(
      'reminders',
      {'is_deleted': 1}, // Mark as deleted
      where: 'id = ?',
      whereArgs: [reminderId],
    );
  }
}
