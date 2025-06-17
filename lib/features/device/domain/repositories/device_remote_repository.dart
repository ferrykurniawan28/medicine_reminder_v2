import 'package:medicine_reminder/features/device/data/models/device_model.dart';

abstract class DeviceRemoteRepository {
  Future<DeviceModel> fetchDevices({int? userId});
  Future<void> addDevice(DeviceModel deviceJson);
  Future<void> updateDevice(int id, DeviceModel deviceJson);
  Future<void> deleteDevice(int id);
  Future<void> syncDevices(List<Map<String, dynamic>> devicesToSync);
}
