import '../models/device_model.dart';

abstract class DeviceLocalDataSource {
  Future<DeviceModel?> getDevice(int id);
  Future<List<DeviceModel>> getDevices();
  Future<void> updateDevice(DeviceModel device);
  Future<void> refreshDevice();
  Future<void> deleteDevice();
}
