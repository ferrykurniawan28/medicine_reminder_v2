import 'package:medicine_reminder/features/device/data/models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<DeviceModel> fetchDevice(int userId);
  Future<DeviceModel> addDevice(int userId, String deviceUid);
  Future<void> updateDevice(DeviceModel device);
  Future<void> deleteDevice(int deviceId);
}
