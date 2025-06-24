import 'package:medicine_reminder/features/device/domain/entities/device_control.dart';

import '../repositories/device_repository.dart';

class GetDeviceControl {
  final DeviceRepository repository;

  GetDeviceControl(this.repository);

  Future<List<DeviceControl>?> call(int deviceId) async {
    return await repository.getDeviceControl(deviceId);
  }
}
