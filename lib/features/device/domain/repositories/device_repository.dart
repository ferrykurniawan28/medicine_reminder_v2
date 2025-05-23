import '../entities/device.dart';

abstract class DeviceRepository {
  Future<Device?> getDevice(int id);
  Future<List<Device>> getDevices();
  Future<void> updateDevice(Device device);
  Future<void> refreshDevice();
  Future<void> deleteDevice();
}
