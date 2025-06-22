import 'package:medicine_reminder/features/device/data/models/device_control_model.dart';
import 'package:medicine_reminder/features/device/data/models/device_model.dart';

abstract class DeviceRemoteDataSource {
  Future<DeviceModel> fetchDevice(int userId);
  Future<List<DeviceControlModel>> fetchDeviceControl(int deviceId,
      {int limit = 10, int offset = 0});
  Future<DeviceModel> addDevice(int userId, String deviceUid);
  Future<void> updateContainer(int userId, ContainerModel container);
  Future<void> resetContainer(int userId, int containerId);
  Future<void> deleteDevice(int deviceId);
  Future<int> getDeviceControlCount(int deviceId);
}
