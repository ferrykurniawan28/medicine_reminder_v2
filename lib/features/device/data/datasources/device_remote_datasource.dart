import 'package:medicine_reminder/features/device/data/models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<DeviceModel> fetchDevice(int userId);
  Future<DeviceModel> addDevice(int userId, String deviceUid);
  Future<void> updateContainer(int userId, ContainerModel container);
  Future<void> resetContainer(int userId, int containerId);
  Future<void> deleteDevice(int deviceId);
}
