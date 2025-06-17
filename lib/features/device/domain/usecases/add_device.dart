import 'package:medicine_reminder/features/device/domain/entities/device.dart';

import '../repositories/device_repository.dart';

class AddDevice {
  final DeviceRepository repository;

  AddDevice(this.repository);

  Future<Device> call(int userId, String deviceUid) async {
    return await repository.addDevice(userId, deviceUid);
  }
}
