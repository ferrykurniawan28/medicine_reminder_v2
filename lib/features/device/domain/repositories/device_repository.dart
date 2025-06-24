import 'package:medicine_reminder/features/device/domain/entities/container.dart';
import 'package:medicine_reminder/features/device/domain/entities/device_control.dart';

import '../entities/device.dart';

abstract class DeviceRepository {
  Future<Device?> getDevice(int deviceId);
  // Future<DeviceModel> getDevices(int userId);
  Future<Device> addDevice(int userId, String deviceUid);
  // Future<void> updateDevice(Device device);
  Future<void> updateContainer(int userId, DeviceContainer container);
  Future<void> resetContainer(int userId, int containerId);
  Future<void> deleteDevice(int userId, int deviceId);
  Future<int> getDeviceControlCount(int deviceId);
  Future<List<DeviceControl>?> getDeviceControl(int deviceId);
}
