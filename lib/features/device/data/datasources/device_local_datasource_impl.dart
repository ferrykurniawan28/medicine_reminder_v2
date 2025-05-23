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
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE device(
            id INTEGER PRIMARY KEY,
            uuid TEXT,
            current_state INTEGER,
            temperature INTEGER,
            humidity INTEGER
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
      },
    );
  }

  @override
  Future<DeviceModel?> getDevice(int id) async {
    final db = await database;
    final deviceMap =
        await db.query('device', where: 'id = ?', whereArgs: [id]);
    if (deviceMap.isEmpty) return null;
    final containersMap =
        await db.query('containers', where: 'device_id = ?', whereArgs: [id]);
    return DeviceModel(
      id: deviceMap[0]['id'] as int?,
      uuid: deviceMap[0]['uuid'] as String,
      currentState: deviceMap[0]['current_state'] as int,
      temperature: deviceMap[0]['temperature'] as int?,
      humidity: deviceMap[0]['humidity'] as int?,
      containers: containersMap
          .map((c) => ContainerModel(
                id: c['id'] as int?,
                deviceId: c['device_id'] as int,
                containerId: c['container_id'] as int,
                medicineName: c['medicine_name'] as String?,
                quantity: c['quantity'] as int?,
              ))
          .toList(),
    );
  }

  @override
  Future<List<DeviceModel>> getDevices() async {
    final db = await database;
    final deviceMaps = await db.query('device');
    List<DeviceModel> devices = [];
    for (final device in deviceMaps) {
      final containersMap = await db.query('containers',
          where: 'device_id = ?', whereArgs: [device['id']]);
      devices.add(DeviceModel(
        id: device['id'] as int?,
        uuid: device['uuid'] as String,
        currentState: device['current_state'] as int,
        temperature: device['temperature'] as int?,
        humidity: device['humidity'] as int?,
        containers: containersMap
            .map((c) => ContainerModel(
                  id: c['id'] as int?,
                  deviceId: c['device_id'] as int,
                  containerId: c['container_id'] as int,
                  medicineName: c['medicine_name'] as String?,
                  quantity: c['quantity'] as int?,
                ))
            .toList(),
      ));
    }
    return devices;
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
    for (final container in device.containers.take(5)) {
      await db.insert('containers', {
        'device_id': container.deviceId,
        'container_id': container.containerId,
        'medicine_name': container.medicineName,
        'quantity': container.quantity,
      });
    }
  }

  @override
  Future<void> refreshDevice() async {
    // No-op for local only, or could re-fetch from db
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> deleteDevice() async {
    final db = await database;
    await db.delete('containers');
    await db.delete('device');
  }
}
