import 'package:medicine_reminder/features/device/data/datasources/device_local_datasource.dart';
import 'package:medicine_reminder/features/device/data/datasources/device_remote_datasource.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';

abstract class DeviceRepository {
  Future<DeviceModel> getDevices(int userId);
  Future<void> addDevice(int userId, String deviceUid);
  Future<void> updateDevice(DeviceModel device);
  Future<void> deleteDevice(int deviceId);
}
