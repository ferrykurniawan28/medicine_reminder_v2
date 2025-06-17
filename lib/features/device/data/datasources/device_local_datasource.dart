import '../models/device_model.dart';

abstract class DeviceLocalDataSource {
  Future<DeviceModel> getDevice(int deviceId);
  Future<void> addDevice(DeviceModel device);
  Future<void> updateDevice(DeviceModel device);
  Future<void> deleteDevice(int deviceId);
  Future<void> addUserDevice(int userId, int deviceId);
  Future<int?> getDeviceIdByUserId(int userId);
  Future<void> deleteUserDevice(int userId, int deviceId);
}
