import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'device_local_datasource.dart';
import '../models/device_model.dart';

class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'device.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE device(
            id INTEGER PRIMARY KEY,
            uuid TEXT,
            current_state INTEGER,
            temperature REAL,
            humidity REAL
          )
        ''');
        await db.execute('''
          CREATE TABLE containers(
            id INTEGER PRIMARY KEY,
            device_id INTEGER,
            container_id INTEGER,
            medicine_name TEXT,
            quantity INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE user_device(
            user_id INTEGER,
            device_id INTEGER,
            PRIMARY KEY (user_id, device_id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // if (oldVersion < 2) {
        //   await db.execute(
        //       'ALTER TABLE device ADD COLUMN is_synced INTEGER DEFAULT 0');
        //   await db.execute(
        //       'ALTER TABLE containers ADD COLUMN is_synced INTEGER DEFAULT 0');
        // }
      },
    );
  }

  @override
  Future<DeviceModel> getDevice(int deviceId) async {
    final db = await database;
    final deviceData =
        await db.query('device', where: 'id = ?', whereArgs: [deviceId]);

    if (deviceData.isEmpty) throw Exception('Device not found');

    final containerData = await db
        .query('containers', where: 'device_id = ?', whereArgs: [deviceId]);

    final containers = containerData
        .map((container) => ContainerModel(
              id: container['id'] as int,
              deviceId: container['device_id'] as int,
              containerId: container['container_id'] as int,
              medicineName: container['medicine_name'] as String?,
              quantity: container['quantity'] as int,
            ))
        .toList();

    return DeviceModel(
      id: deviceData.first['id'] as int,
      uuid: deviceData.first['uuid'] as String,
      currentState: deviceData.first['current_state'] as int,
      temperature: deviceData.first['temperature'] as double?,
      humidity: deviceData.first['humidity'] as double?,
      containers: containers,
    );
  }

  @override
  Future<void> addDevice(DeviceModel device) async {
    final db = await database;
    // Enforce only one device and 5 containers: clear tables before insert
    await db.delete('device');
    await db.delete('containers');
    // Insert the device
    await db.insert('device', {
      'id': device.id,
      'uuid': device.uuid,
      'current_state': device.currentState,
      'temperature': device.temperature,
      'humidity': device.humidity,
    });
    // Insert up to 5 containers
    for (final container in device.containers.take(5)) {
      await db.insert('containers', {
        'id': container.id,
        'device_id': container.deviceId,
        'container_id': container.containerId,
        'medicine_name': container.medicineName,
        'quantity': container.quantity,
      });
    }
  }

  @override
  Future<void> updateDevice(DeviceModel device) async {
    final db = await database;
    // Enforce only one device and 5 containers: clear tables before insert
    await db.delete('device');
    await db.delete('containers');
    // Insert the device
    await db.insert('device', {
      'uuid': device.uuid,
      'current_state': device.currentState,
      'temperature': device.temperature,
      'humidity': device.humidity,
    });
    // Insert up to 5 containers
    for (final container in device.containers) {
      await db.insert('containers', {
        'device_id': container.deviceId,
        'container_id': container.containerId,
        'medicine_name': container.medicineName,
        'quantity': container.quantity,
      });
    }
  }

  @override
  Future<void> deleteDevice(int deviceId) async {
    final db = await database;
    await db.delete('device', where: 'id = ?', whereArgs: [deviceId]);
  }

  @override
  Future<void> addUserDevice(int userId, int deviceId) async {
    final db = await database;
    await db.insert('user_device', {
      'user_id': userId,
      'device_id': deviceId,
    });
  }

  @override
  Future<int?> getDeviceIdByUserId(int userId) async {
    final db = await database;
    final result = await db.query(
      'user_device',
      columns: ['device_id'],
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first['device_id'] as int?;
    }
    return null;
  }

  @override
  Future<void> deleteUserDevice(int userId, int deviceId) async {
    final db = await database;
    await db.delete(
      'user_device',
      where: 'user_id = ? AND device_id = ?',
      whereArgs: [userId, deviceId],
    );
  }
}
