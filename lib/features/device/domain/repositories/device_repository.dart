import '../entities/device.dart';

abstract class DeviceRepository {
  Future<Device?> getDevice(int deviceId);
  // Future<DeviceModel> getDevices(int userId);
  Future<Device> addDevice(int userId, String deviceUid);
  Future<void> updateDevice(Device device);
  Future<void> deleteDevice(int deviceId);
}
